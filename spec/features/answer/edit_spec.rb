require 'rails_helper'

feature 'User can edit his answer' do
  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: users.first) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link(class: 'edit-answer-link', id: answer.id)
  end

  describe 'Authenticated user' do
    describe 'edit his answer', js: true do
      before do
        sign_in(users.first)
        visit question_path(question)
        find(:css, 'i.fas.fa-edit').click
      end

      scenario 'without errors' do
        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edits his answer with error', js: true do
        within '.answers' do
          fill_in 'Your answer', with: ''
          click_on 'Save'
        end
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's question" do
      sign_in(users.last)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end
