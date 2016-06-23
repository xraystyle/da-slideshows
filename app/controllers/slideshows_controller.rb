class SlideshowsController < ApplicationController

  # require 'json'
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:slideshow, :update_slideshow]


  @@wh = "00000000-0000-0000-0000-000000000001"

  # Set up data to display the channel changer.
  def channels

    @user_seed = current_user.seed

    # whats_hot = Slideshow.whats_hot_slideshow

    @channels = Slideshow.whats_hot_slideshow.results.order(created_at: :desc).map { |d| {thumb: d.thumb.sub!(/https/, 'http'), uuid: d.uuid} }.compact # change .results to .nsfw for mature filter.

    # If a slideshow doesn't exist for a given seed, having it show up in the channel changer will produce errors if it's
    # selected as the user's channel. This happens when What's Hot has been updated, but before all the MLT results have been
    # retrieved for deviations new to the What's Hot list. Selecting channels only if the associated slideshow exists
    # prevents this error.
    @channels.select! { |c| Slideshow.exists?(seed: c[:uuid]) }

  end


  # Set up data to display the slideshow.
  def slideshow
    if current_user
      @user_id = current_user.uuid
    elsif params[:id]
      user = User.where(uuid: params[:id]).first
      redirect_to root_path and return unless user
      @user_id = user.uuid
    else
      redirect_to root_path and return
    end
  end



  

  # Show the logged in user's homepage. Should have links to the
  # channel changer, the slideshow, and the user profile editing
  # pages. Create a uuid unless one already exists.
  def home
    unless current_user.uuid?
      current_user.create_uuid 
      current_user.save
    end
    @uuid = current_user.uuid
  end



  # only called via AJAX. 
  def update_slideshow

    # If we get :set_uuid, we're trying to change channels on the slideshow.
    if params[:set_uuid]
      # gotta be logged in to change channels.
      render nothing: true, status: :unauthorized and return unless current_user 

      current_user.seed = params[:set_uuid]
      current_user.save
      # Add a view count to the slideshow.
      Slideshow.transaction do
        selected = Slideshow.lock("FOR SHARE").where(seed: params[:set_uuid]).first
        selected.increment!(:views)
      end

      render status: 200, json: @controller.to_json

    # If we get :current_seed, we're on the slideshow page, checking for updates.
    elsif params[:current_seed] 
      #find the user by the uuid. Will always be present so we don't neeed current_user.
      user = User.where(uuid: params[:user_id]).first
      render nothing: true, status: :expectation_failed and return unless user # Bail if no user found.
      
      seed_in_db = user.seed

      if seed_in_db == params[:current_seed]
        render json: { update: "false" } # nothing to do boat.
      else

        url_hash = { seed: seed_in_db }
        first_deviation = Deviation.where(uuid: seed_in_db).first

        url_hash[0] = { url: first_deviation.src.sub(/https/, 'http'), title: first_deviation.title, author: first_deviation.author, link: first_deviation.url } if first_deviation

        deviations = user.slideshow.results # add .where(mature: false) for mature filter.
        urls = deviations.map { |d| { url: d.src.sub(/https/, 'http'), title: d.title, author: d.author, link: d.url } }.compact

        urls.each_with_index do |u,i|
          if first_deviation
            url_hash[i+1] = u
          else
            url_hash[i] = u
          end

        end
        render json: url_hash
      end

    else
      render status: 200, json: @controller.to_json
    end

  end

end
