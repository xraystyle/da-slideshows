class RegistrationsController < Devise::RegistrationsController


  def create
    super
    WelcomeMailer.delay.welcome(@user.email) unless @user.invalid?
  end





end