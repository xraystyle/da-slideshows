class RegistrationsController < Devise::RegistrationsController


  def create
    super

    unless @user.invalid?
      WelcomeMailer.delay.welcome(@user.email)
      WelcomeMailer.delay.notify_me(@user.email)
    end

  end


end
