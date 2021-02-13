require 'rails_helper'

feature 'User can edit his question' do
  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users.first) }

  describe 'authenticated user' do
    before do
      sign_in(users.first)
      visit edit_question_path(question)
    end

    scenario 'edits his question' do
      fill_in 'Title', with: 'new title'
      fill_in 'Body', with: 'new body'
      click_on 'Update'

      expect(page).to have_content 'new title'
      expect(page).to have_content 'new body'
    end

    scenario 'edits his answer with errors' do
      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Update'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated can not edit question' do
    sign_in(users.last)
    visit edit_question_path(question)

    expect(page).to_not have_link 'Update'
  end
end
