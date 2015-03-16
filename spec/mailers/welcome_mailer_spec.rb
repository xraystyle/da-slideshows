require "rails_helper"

RSpec.describe WelcomeMailer, :type => :mailer do

  describe "Welcome Email" do
    
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { WelcomeMailer.welcome(user.email) }

    it "renders the subject" do
      expect(mail.subject).to eq("Welcome to DA Slideshows!")
    end

    it "sends to the correct email address" do
      expect(mail.to).to eq(user.email)
    end

    it "is sent from the correct address" do
      expect(mail.from).to eq('info@da-slidesho.ws')
    end


  end





end
