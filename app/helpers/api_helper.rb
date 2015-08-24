require 'open-uri'
require 'json'

module ApiHelper

  include ApplicationHelper

  # Retrieve a new API Access token from DA. Required for other API calls.
  def get_new_api_token
    json_response = open('https://www.deviantart.com/oauth2/token?grant_type=client_credentials&client_id=' +
                          DA_CLIENT_ID + '&client_secret=' + DA_CLIENT_SECRET).read
    token_data = JSON.parse(json_response)

    # if the JSON object has the key "error", something went sideways.
    if token_data["error"]
      log_message("Error retrieving access token from DA.", log_level: "error", logfile: "api_calls.log")
      log_message(token_data["error_description"], log_level: "error", logfile: "api_calls.log")
    else
      # If it doesn't, we got an access token.
      # Tokens are valid for 3600 seconds. Cache it in Redis for
      # slightly less than that so we can re-use it and only
      # reauth when necessary.
      log_message("Access token retrieved, setting in Redis.", logfile: "api_calls.log")
      $redis.multi do
        $redis.set("access_token", token_data["access_token"])
        $redis.expire("access_token", 3585)
      end
    end

  end


  # Check the current API token to see if it's fresh enough to use.
  # If it's not, refresh it from DA. If it is, load and return it.
  def load_api_token

    unless $redis.ttl("access_token") > 30
      log_message("Access token expires soon. Renewing...", logfile: "api_calls.log")
      get_new_api_token
    end

    $redis.get("access_token")

  end


  # Add a passed array of deviation objects to the Deviations table.
  # Optionally add them to a slideshow, if a slideshow seed is passed.
  # deviations_array should be an array of deviation objects as returned
  # from the API.
  def add_deviations_to_db(deviations_array, slideshow_seed = nil)

    if slideshow_seed
      # Find the passed slideshow if there's a seed given.
      # If it doesn't exist, it'll return nil.
      slideshow = Slideshow.includes(:deviations).where(seed: slideshow_seed).first

      # If we didn't get a slideshow from the passed seed, we need to make it.
      unless slideshow
        slideshow = Slideshow.create(seed: slideshow_seed)
      end

    else # no slideshow to deal with
      slideshow = false
    end

    # Get the UUUIDs of every deviation in our slideshow into a set.
    # Then we can quickly check to see if our deviation is already
    # associated to the slideshow if it's already in the DB.
    # This eliminates repetitive INSERT attempts into deviations_slideshows
    # if the two are already associated.
    slideshow_uuid_set = slideshow.deviations.map { |d| d.uuid }.to_set if slideshow

    deviations_array.each do |entry|

      # Check to see if the uuid of the deviation is in the db. 
      # If it is, set it to true so we can associate it to the slideshow if we have one.
      if Deviation.exists?(uuid: entry["deviationid"])
        existing_deviation = true
      else
        existing_deviation = false
      end

      # If the deviation exists and there's no slideshow, nothingtodoboat.jpg
      next if existing_deviation && slideshow == false

      # If the deviation is already in the DB, add it to the
      # slideshow and move to the next deviation.
      if existing_deviation && slideshow
        # Check to see if the UUID of the deviation is already associated
        # with the slideshow. Associate it unless it's already there.
        unless slideshow_uuid_set.include?(uuid)

          begin
            # log_message("Adding #{uuid} to slideshow #{slideshow.seed}", log_level: "info")
            slideshow.deviations << Deviation.where(uuid: uuid).first
          rescue => e
            log_message("Couldn't add deviation #{uuid} to slideshow #{slideshow.seed}.", log_level: "error")
            log_message(e.inspect, log_level: "error")
          end

        end
        # Move on to the next deviation.
        next

      end


      # non-standard deviations like journals don't have a 'src'.
      # Skip 'em.
      next unless entry["content"]
      # Skip lit, even if it has a preview image.
      # See this deviation for an example of why:
      # http://vinyl----scratch.deviantart.com/art/Becoming-the-Baby-ABDL-Story-PART-1-365597841
      next if /literature/ =~ entry["category_path"]

      # Get all the pieces we need to make a new database entry.
      url = entry["url"]
      title = entry["title"]
      author = entry["author"]["username"]
      mature = entry["is_mature"]
      uuid = entry["deviationid"]
      src = entry["content"]["src"].sub(/http:/, "https:")
      thumb = entry["thumbs"].last["src"].sub(/http:/, "https:")

      # We don't need height and width on their own, but it makes
      # the orientation calculation easier to read. Might be interesting
      # later anyway.
      height = entry["content"]["height"]
      width = entry["content"]["width"]

      # Figure out the orientation based on width and height.
      if width > height
        orientation = "landscape"
      elsif width < height
        orientation = "portrait"
      elsif width == height
        orientation = "square"
      end

      # Make our new deviation.
      begin

        new_deviation = Deviation.create!(url: url,
                                         title: title,
                                         author: author,
                                         mature: mature,
                                         uuid: uuid,
                                         src: src,
                                         thumb: thumb,
                                         orientation: orientation)

      rescue => e
        log_message("Deviation with UUID #{uuid} failed to save.", log_level: "error")
        log_message(e.inspect, log_level: "error")
      end

      # if we have a slideshow to add it to, do that now.
      begin
        if slideshow
          # log_message('New deviation created, adding to slideshow.', log_level: "info")
          insert = "INSERT INTO deviations_slideshows (deviation_id, slideshow_id) VALUES (#{new_deviation.id}, #{slideshow.id})"
          ActiveRecord::Base.connection.execute(insert)
          # slideshow.deviations << new_deviation 
        end
      rescue => e
        log_message("Couldn't add deviation #{uuid} to slideshow #{slideshow.seed}.", log_level: "error")
        log_message(e.inspect, log_level: "error")
      end

    end

  end


  # Retrieve the deviations from the "What's Hot" page.
  # Get 144 results (24*6). Max results per page is 24,
  # so iterate 6 times. Add all the resulting deviation
  # objects to a single array and return it for insertion
  # into the DB by another method.
  # https://www.deviantart.com/developers/http/v1/20150106/object/deviation
  def get_whats_hot

    log_message("Getting What's Hot...", logfile: "api_calls.log", log_level: "info")

    # Get all the current whats_hot deviations so we can remove any stale ones after the update.
    whats_hot = Slideshow.whats_hot_slideshow

    deviations = [] # Hold all the deviation objects we get.
    failure_count = 0 # Count api call errors
    offset = 0 # page offset for what's hot

    # Load up the API token.
    access_token = load_api_token

    # We don't need more than about 250 deviations from What's Hot to be offered as channels in the
    # channel changer.
    while deviations.count <= 250 do
        begin
          json_response = open("https://www.deviantart.com/api/v1/oauth2/browse/hot?offset=#{offset}&limit=24&access_token=#{access_token}&mature_content=true").read
        rescue => e
          # Set a fake value for whats_hot_page["error"] so we can log it below.
          json_response = {error: e}.to_json
        end

        whats_hot_page = JSON.parse(json_response)

        # If we get an error, log it and try again.
        if whats_hot_page["error"]

          log_message("Error retrieving page #{(offset / 24) + 1} of What's Hot, retrying.", logfile: "api_calls.log", log_level: "error")
          log_message(whats_hot_page["error_description"], logfile: "api_calls.log", log_level: "error")

          # Increment the failure count. If we've tried 10 times, bail.
          # Otherwise, next.
          failure_count += 1
          if failure_count >= 10
            log_message("Tried 10 times, something is borked.", logfile: "api_calls.log", log_level: "error")
            break
          end

          next

        else
          # add the retrieved deviations
          deviations = deviations + whats_hot_page["results"]

          # check for MOAR
          if whats_hot_page["has_more"] == true
            offset = whats_hot_page["next_offset"]
          else
            # No MOAR. Stop looking.
            break
          end

        end

      end

      # Add the found deviations to the database and associate with whats_hot
      add_deviations_to_db(deviations, "00000000-0000-0000-0000-000000000001")

      # Remove any deviations from whats_hot that aren't in the list of deviations that were retrieved.
      fresh_deviation_ids = deviations.map { |d| d["deviationid"] }

      whats_hot.deviations.each do |d|

        whats_hot.deviations.delete(d) unless fresh_deviation_ids.include?(d.uuid)

      end

  end

    # Make the MLT call for the given seed deviation uuid.
    # Put all the deviation objects into a single array, suitable for
    # passing into the add_deviations_to_db method above. Pass in the
    # given seed uuid as the slideshow seed as well.
  def get_mlt_results(seed_uuid)
    log_message("Getting MLT for seed #{seed_uuid}...", log_level: "info", logfile: "api_calls.log")
    # First, load our API token
    access_token = load_api_token

    # Set up some variables
    deviations = [] # Hold all the deviation objects we get.
    has_more = true # This will be false when we run out of results.
    offset = 0 # Keep track of our page offset for MLT calls.
    failure_count = 0 # Keep track of errors when making API calls.

    # Keep going until we get all the pages.
    while has_more == true

      # Make the API call to DA for MLT results for the given seed UUID.
      begin
        json_response = open("https://www.deviantart.com/api/v1/oauth2/browse/morelikethis?limit=24&offset=#{offset}&seed=#{seed_uuid}&access_token=#{access_token}&mature_content=true").read
      rescue => e
        # set mlt_results["error"] so we can log it below.
        json_response = {error: e}.to_json
      end

      mlt_results = JSON.parse(json_response)

      # If we get an error, log it and try again.
      if mlt_results["error"]

        log_message("Error retrieving MLT for seed #{seed_uuid}, page #{(offset / 24) + 1}. Retrying.", log_level: "error", logfile: "api_calls.log")
        log_message(mlt_results["error_description"], log_level: "error", logfile: "api_calls.log")

        # Increment the error count and try again. If we've already tried
        # 10 times, bail.
        failure_count += 1

        if failure_count >= 10
          log_message("Tried 10 times, something is borked.", logfile: "api_calls.log", log_level: "error")
          break
        end

        next

      end

      # MLT call successful.
      # log_message("MLT successfully retrieved for seed #{seed_uuid}, page #{(offset / 24) + 1}", logfile: "api_calls.log")

      # Add the deviations to our array.
      deviations = deviations + mlt_results["results"]

      # 300 deviations in a slideshow at 5 sec. per slide is 25 minutes with no repeats.
      # That's plenty. Break when we hit 300 unless we already ran out of results.
      # There are deviations with THOUSANDS of MLT results. Unless we break at an arbitrary number
      # We could end up completely filling the database on a few MLT calls.
      if deviations.count >= 300
        break
      end

      # If we still have less than 300 deviations and there's more pages of results,
      # update offset, has_more, and do another loop.
      offset = mlt_results["next_offset"]
      has_more = mlt_results["has_more"]

    end

    # Add our 300-odd deviations to the database and associate them with the slideshow seed.
    add_deviations_to_db(deviations, seed_uuid)

  end


end  # end ApiHelper
