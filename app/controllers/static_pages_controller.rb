class StaticPagesController < ApplicationController
  
  def home
    # ExampleMailer.sample_email.deliver
  	render 'slideshows/home' if user_signed_in?
  end

end
