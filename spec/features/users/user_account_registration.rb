require 'rails_helper'

describe "New user signs up for an account" do

  scenario 'with valid crendentials' do
    visit root_path
    click_link 'Register'
    fill_in 'Email', with: 'someuser@example.com'
    fill_in 'Password', with: "foobar"
    fill_in 'Password confirmation', with: "foobar"
    
    expect do
      click_button 'Sign up'
    end.to change(User, :count).by(1)

    expect(page).to have_content "user@example.com"
    expect(page).to have_content "Channel Changer"
    expect(page).to have_content "My Slideshow"
  end

  scenario 'with an invalid email address' do
    visit root_path
    click_link 'Register'
    fill_in 'Email', with: 'invalid@foo'
    fill_in 'Password', with: "foobar"
    fill_in 'Password confirmation', with: "foobar"
    
    expect do
      click_button 'Sign up'
    end.not_to change(User, :count)

    expect(page).to have_content 'Email is invalid'
  end

  scenario 'with an invalid password' do
    visit root_path
    click_link 'Register'
    fill_in 'Email', with: 'someuser@example.com'
    fill_in 'Password', with: "foo"
    fill_in 'Password confirmation', with: "foo"
    
    expect do
      click_button 'Sign up'
    end.not_to change(User, :count)

    expect(page).to have_content 'Password is too short (minimum is 6 characters)'
  end

  scenario 'with mistyped password validation' do
    visit root_path
    click_link 'Register'
    fill_in 'Email', with: 'someuser@example.com'
    fill_in 'Password', with: "foobar"
    fill_in 'Password confirmation', with: "foobaz"

    expect do
      click_button 'Sign up'
    end.not_to change(User, :count)
    
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  
end