require 'rails_helper'

describe "New user signs up for an account" do

  scenario 'with valid crendentials' do
    visit root_path
    click_link 'Register'
    fill_in 'Email', with: 'someuser@example.com'
    fill_in 'Password', with: "foobar"
    fill_in 'Password confirmation', with: "foobar"
    puts "running feature spec"
    expect(page).to have_content "user@example.com"


    
  end
  
end