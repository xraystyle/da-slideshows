class StaticPagesController < ApplicationController

  def home
    # ExampleMailer.delay.sample_email
    render 'slideshows/home' if user_signed_in?
  end

end
