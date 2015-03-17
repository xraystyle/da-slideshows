class WelcomeMailerPreview < ActionMailer::Preview 

  def welcome
    WelcomeMailer.welcome("test@example.com")
  end

end