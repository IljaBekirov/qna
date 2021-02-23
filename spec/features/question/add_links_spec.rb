require 'rails_helper'

feature 'User can add links to question' do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/IljaBekirov/5baa801d531d14eeb2044328caa7f918' }
  given(:bad_url) { 'bad_url.com' }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds link when asks question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end

  scenario 'User add link with errors' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: ''
    fill_in 'Url', with: bad_url

    click_on 'Ask'

    expect(page).to have_content 'Links url is invalid'
    expect(page).to have_content "Links name can't be blank"
  end
end
