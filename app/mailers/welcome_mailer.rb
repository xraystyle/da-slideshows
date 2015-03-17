class WelcomeMailer < ActionMailer::Base
  default from: "info@da-slidesho.ws"

  # WELCOME_TEXT = open("lib/assets/welcome_email.txt").read



  def welcome(user_email)
    
    # mg_client = Mailgun::Client.new ENV["MG_API_KEY"]
    # message_params = {from: "info@da-slidesho.ws",
    #                   to: user_email,
    #                   subject: "Welcome to DA Slideshows!",
    #                   text: WELCOME_TEXT
    #                   }
    # mg_client.send_message ENV["MG_DOMAIN"], message_params

    mail to: user_email, subject: "Welcome to DA Slideshows!"



  end

end
