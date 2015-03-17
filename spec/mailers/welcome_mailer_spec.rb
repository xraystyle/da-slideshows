require "rails_helper"

RSpec.describe WelcomeMailer, :type => :mailer do

  describe "Welcome Email" do
    
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { WelcomeMailer.welcome(user.email) }

    it "renders the subject" do
      expect(mail.subject).to eq("Welcome to DA Slideshows!")
    end

    it "sends to the correct email address" do
      expect(mail.to).to eq([user.email])
    end

    it "is sent from the correct address" do
      expect(mail.from).to eq(['info@da-slidesho.ws'])
    end

  end

  describe "Notification Email" do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { WelcomeMailer.notify_me(user.email) }

    it "sends email to me when a new user signs up" do
      expect(mail.to).to eq(["bclevin@gmail.com"])
    end

    it "is sent from the correct address" do
      expect(mail.subject).to eq("New user just registered!")
    end

    it "contains the email address of the new account" do
      expect(mail.body.encoded).to match(user.email)
    end

  end

end
