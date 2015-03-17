class WelcomeMailer < ActionMailer::Base
  default from: "info@da-slidesho.ws"

  def welcome(user_email)
    mail to: user_email, subject: "Welcome to DA Slideshows!"
  end

  def notify_me(user_email)
    @email = user_email
    mail from: "signups@da-slidesho.ws", to: 'bclevin@gmail.com', subject: "New user just registered!"
  end

end
