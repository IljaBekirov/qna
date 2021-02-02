require 'rails_helper'

feature 'User can view a list of questions ' do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }

  scenario 'Authenticated user view a list of questions' do
    sign_in(user)
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

  scenario 'Unauthenticated user tries to view a list of questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
