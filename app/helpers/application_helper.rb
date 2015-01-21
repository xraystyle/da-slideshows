require 'open-uri'
require 'json'

module ApplicationHelper

	# Simple method to make logging to the Rails logger easier,
	# faster and cleaner.
	def log_message(message, options = { })
		
		# If a logfile is specified, make the logger with that file as 
		# the output. Fall back to the env log.
		if options[:logfile]
			log = Rails.root.to_s + "/log/" + options[:logfile]
			logger = Logger.new(log)
		else
			default_log = Rails.root.to_s + "/" + Rails.env + ".log"
			logger = Logger.new(default_log)
		end


		case options[:log_level]
		when "info", nil
			logger.info message.to_s
		when "warning"
			logger.warn message.to_s
		when "error"
			logger.error message.to_s
		end
		
	end


	# Retrieve a new API Access token from DA. Required for other API calls.
	def get_api_token
		response = open("https://www.deviantart.com/oauth2/token?grant_type=client_credentials&client_id=2220&client_secret=489e314d779745dd3ba3297b6e28900e&").read
		json = JSON.parse(response)

		# if the JSON object has the key "error", something sent sideways.
		if json["error"]
			log_message("Error retrieving API token from DA.", log_level: "error", logfile: "api_calls.log")
			log_message(json["error_description"], log_level: "error", logfile: "api_calls.log")
		else
			# If it doesn't, we got an access token. 
			# Tokens are valid for 3600 seconds. Cache it in Redis for 
			# slightly less than that so we can re-use it and only 
			# reauth when necessary.
			log_message("API key retrieved, setting in Redis.", logfile: "api_calls.log")
			$redis.multi do
				$redis.set("access_token", json["access_token"])
				$redis.expire("access_token", 3585)
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
		unless $redis.ttl("access_token") > 30
			log_message("Access token expires soon. Renewing...", logfile: "api_calls.log")
			get_api_token
		end

		deviations = [] # Hold all the deviation objects we get. Return this value.
		failure_count = 0 # Count api call errors
		offset = 0 # page offset for what's hot

		access_token = $redis.get("access_token")

		while deviations.count <= 250 do
			response = open("https://www.deviantart.com/api/v1/oauth2/browse/hot?offset=#{offset}&limit=24&access_token=#{access_token}&mature_content=true").read

			api_object = JSON.parse(response)

			if api_object["error"]
				
				log_message("Error retrieving page #{(offset / 24) + 1} of What's Hot, retrying.", logfile: "api_calls.log", log_level: "error")
				log_message(api_object["error_description"], logfile: "api_calls.log", log_level: "error")
				
				# Increment the failure count. If we've tried 10 times, bail.
				# Otherwise, next.
				failure_count += 1
				if failure_count >= 10
					log_message("Tried 10 times, something is borked.", logfile: "api_calls.log", log_level: "error")
					break
				end

				next

			else
				log_message("Deviations successfully retrieved, What's Hot page #{(offset / 24) + 1}", logfile: "api_calls.log")
				# add the retrieved deviations
				deviations = deviations + api_object["results"]

				# check for MOAR
				if api_object["has_more"] == true
					offset = api_object["next_offset"]
				else
					# No MOAR. Stop looking.
					break
				end

			end

		end
		
		return deviations

	end

	# Add a passed array of deviation objects to the Deviations table.
	# Optionally add them to a slideshow, if a slideshow seed is passed.
	def add_deviations_to_db(deviations_array, slideshow_seed = nil)


		if slideshow_seed
			# Find the passed slideshow if there's a seed given.
			# If it doesn't exist, it'll return nil.
			slideshow = Slideshow.where(seed: slideshow_seed).first

			# If we didn't get a slideshow from the passed seed, we need to make it.
			unless slideshow
				slideshow = Slideshow.create(seed: slideshow_seed)
			end
		else # no slideshow to deal with
			slideshow = false
		end

		deviations_array.each do |entry|

			# non-standard deviations like journals don't have a 'src'.
			# Skip 'em.
			next unless entry["content"]

			# Get all the pieces we need to make a new database entry.
			url = entry["url"]
			title = entry["title"]
			author = entry["author"]["username"]
			mature = entry["is_mature"]
			uuid = entry["deviationid"]
			src = entry["content"]["src"]
			thumb = entry["thumbs"].last["src"]
			
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
			
			# If the UUID is already in the DB, skip it.
			# if it's not there, the lookup will return nil.
			next if Deviation.where(uuid: uuid).first

			# Make our new deviation.
			begin
				
				new_deviation = Deviation.create(url: url,
												 title: title, 
												 author: author,
												 mature: mature,
												 uuid: uuid,
												 src: src,
												 thumb: thumb,
												 orientation: orientation)

			rescue Exception => e
				log_message("Deviation with UUID #{uuid} failed to save.", log_level: "error")
			end


			# if we have a slideshow to add it to, do that now.
			begin
				slideshow.deviations << new_deviation if slideshow
			rescue Exception => e
				log_message("Couldn't add deviation #{uuid} to slideshow #{slideshow.seed}.", log_level: "error")
			end

		end

			
	end




	# def test_logger
	# 	log_message("Test one.", logfile: "test one.log")
	# 	log_message("Test two.", logfile: "redis.log")
	# end

end















