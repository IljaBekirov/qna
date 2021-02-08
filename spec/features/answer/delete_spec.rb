require 'rails_helper'

feature 'User can delete only his own answer' do
  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users.first) }
  given!(:answer) { create(:answer, question: question, user: users.first) }

  describe 'Authenticated user' do
    scenario 'delete his own answer', js: true do
      sign_in(users.first)
      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to_not have_content answer.body
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario "deletes another user's answer" do
      sign_in(users.last)
      visit question_path(question)

      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end
