require 'rails_helper'

feature 'User can delete only his own question' do
  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users.first) }

  describe 'Authenticated user' do
    scenario 'delete his own question' do
      sign_in(users.first)
      visit question_path(question)
      click_on 'Delete question'

      expect(page).to have_content 'Your question successfully deleted!'
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end

    scenario "deletes another user's question" do
      sign_in(users.last)
      visit question_path(question)

      expect(page).to_not have_link 'Delete question'
    end
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end
