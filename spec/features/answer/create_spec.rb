require 'rails_helper'

feature 'User can create answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answer the question' do
      fill_in 'Body', with: 'Answer a question'
      click_on 'Answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Answer a question'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'answer the question with error' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
