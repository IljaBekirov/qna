require 'rails_helper'

feature 'User can sign up' do
  background { visit new_user_registration_path }

  feature 'New user tires to sign up' do
    scenario 'with valid attributes' do
      fill_in 'Email', with: 'email@gmail.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_button 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'with invalid password' do
      fill_in 'Email', with: 'email@gmail.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '1234567'
      click_button 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match Password"
    end

    scenario 'with empty email' do
      fill_in 'Email', with: ''
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_button 'Sign up'

      expect(page).to have_content "Email can't be blank"
    end
  end
end
