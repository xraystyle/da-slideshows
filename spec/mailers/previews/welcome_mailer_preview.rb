class WelcomeMailerPreview < ActionMailer::Preview 

  def welcome
    WelcomeMailer.welcome("test@example.com")
  end

  def notify_me
    WelcomeMailer.notify_me("test@example.com")
  end

end