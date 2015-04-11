# require 'rails_helper'
# require 'sidekiq/testing'

# describe "using the slideshow controller" do
#   let(:user) { FactoryGirl.create(:user) }
#   let(:slideshow) { FactoryGirl.create(:slideshow) }

#   scenario 'selecting a new slideshow' do
#     visit root_path
#     within(".nav") do
#       click_link 'Sign in'
#     end    
#     fill_in 'Email', with: user.email
#     fill_in 'Password', with: user.password
#     click_button 'Sign in'
#     visit slideshows_channels_path
#     find("img")[data-uuid = slideshow.seed].click
#   end


# end