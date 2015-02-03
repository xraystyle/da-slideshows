class SlideshowsController < ApplicationController

	before_action :authenticate_user!

	@@wh = "00000000-0000-0000-0000-000000000001"


	# Set up data to display the channel changer.
	def channels

		@user_seed = current_user.seed

		whats_hot = Slideshow.where(seed: @@wh).first

		@channels = whats_hot.deviations.map { |d| {thumb: d.thumb, uuid: d.uuid} unless d.mature? }.compact

	end


	# Set up data to display the slideshow.
	def slideshow
		@image = Deviation.where(uuid: current_user.seed).first.src
	end

	# Show the logged in user's homepage. Should have links to the
	# channel changer, the slideshow, and the user profile editing
	# pages.
	def home

	end

	def update_slideshow
		
		@image = Deviation.where(uuid: current_user.seed).first.src
		if params[:uuid]
			current_user.seed = params[:uuid]
			current_user.save
			render status: 200, json: @controller.to_json
		else
			render json: {url: @image}
		end

	end



end
