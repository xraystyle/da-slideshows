class StaticPagesController < ApplicationController
  
  def home
  	render 'slideshows/home' if user_signed_in?
  end

end
