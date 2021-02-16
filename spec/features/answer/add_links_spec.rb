require 'rails_helper'

feature 'User can add links to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/IljaBekirov/5baa801d531d14eeb2044328caa7f918' }

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'My answer'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
