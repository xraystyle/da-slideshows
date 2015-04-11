require 'rails_helper'

describe "Current user signs in" do

  let(:user) { FactoryGirl.create(:user) }

  scenario 'with valid credentials' do
    visit root_path
    within(".nav") do
      click_link 'Sign in'
    end    
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    expect(page).to have_content user.email
    expect(page).to have_content "Channel Changer"
    expect(page).to have_content "My Slideshow"    
  end
  
  scenario 'with invalid credentials' do
    visit root_path
    within(".nav") do
      click_link 'Sign in'
    end    
    fill_in 'Email', with: user.email
    fill_in 'Password', with: "notuserpassword"
    click_button 'Sign in'
    expect(page).to have_content 'Invalid email or password.'
  end

end

