class SlideshowsController < ApplicationController

	# require 'json'

	before_action :authenticate_user!

	@@wh = "00000000-0000-0000-0000-000000000001"


	# Set up data to display the channel changer.
	def channels

		@user_seed = current_user.seed

		whats_hot = Slideshow.where(seed: @@wh).first

		@channels = whats_hot.deviations.map { |d| {thumb: d.thumb, uuid: d.uuid} }.compact # add unless d.mature? for mature filter.

	end


	# Set up data to display the slideshow.
	def slideshow
		@current_seed = current_user.seed
	end

	# Show the logged in user's homepage. Should have links to the
	# channel changer, the slideshow, and the user profile editing
	# pages.
	def home

	end

	def update_slideshow

		if params[:set_uuid]
			
			current_user.seed = params[:set_uuid]
			current_user.save
			render status: 200, json: @controller.to_json

		elsif params[:current_seed]

			seed_in_db = current_user.seed

			if seed_in_db == params[:current_seed]
				
				render json: { update: "false" }

			else
				url_hash = { seed: seed_in_db }
				first_deviation = Deviation.where(uuid: seed_in_db).first
				url_hash[0] = { url: first_deviation.src, aspect: first_deviation.orientation }
				deviations = current_user.slideshow.deviations
				urls = deviations.map { |d| { url: d.src, aspect: d.orientation } }.compact

				urls.each_with_index do |u,i|
					url_hash[i+1] = u
				end
				puts "Sending updated URL list..."
				render json: url_hash

			end

		else
			render status: 200, json: @controller.to_json
		end

	end













end
