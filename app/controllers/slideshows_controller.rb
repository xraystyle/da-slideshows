class SlideshowsController < ApplicationController

	before_action :authenticate_user!

	@@wh = "00000000-0000-0000-0000-000000000001"



  def channels
  	@user_seed = current_user.seed

  	whats_hot = Slideshow.where(seed: @@wh).first

  	@channels = whats_hot.deviations.map { |d| {thumb: d.thumb, uuid: d.uuid} unless d.mature? }.compact

  	# @channels = whats_hot.deviations.map do |d|
  	# 	next if d.mature?
  	# 	{thumb: d.thumb, uuid: d.uuid}	
  	# end.compact


  end


















  def slideshow
  end

  def home
  	
  end



end
