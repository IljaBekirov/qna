require 'rails_helper'

feature 'User can add links to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/IljaBekirov/5baa801d531d14eeb2044328caa7f918' }
  given(:bad_url) { 'bad_url.com' }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds link when give an answer', js: true do
    fill_in 'Body', with: 'My answer'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

  scenario 'User add link with errors', js: true do
    fill_in 'Body', with: 'My answer'
    fill_in 'Link name', with: ''
    fill_in 'Url', with: bad_url

    click_on 'Answer'

    expect(page).to have_content 'Links url is invalid'
    expect(page).to have_content "Links name can't be blank"
  end
end
