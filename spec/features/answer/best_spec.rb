require 'rails_helper'

feature 'User can mark best answer' do
  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users.first) }
  given!(:answer) { create(:answer, question: question, user: users.first) }
  given!(:question_with_best_answer) { create(:question, user: users.first, best_answer_id: answer.id) }
  given!(:second_answer) { create(:answer, question: question, user: users.first) }
  given!(:best_answer) { question_with_best_answer.best_answer }
  let(:top_answer) { page.find(:css, 'div.best_answer') }

  describe 'Authenticated user' do
    scenario 'one best answer', js: true do
      sign_in(users.first)
      visit question_path(question)
      click_on(id: "best_#{answer.id}")

      expect(page).to have_css('div.best_answer')
      expect(top_answer).to have_content answer.body
    end

    scenario 'second answer the best', js: true do
      sign_in(users.first)
      visit question_path(question)
      click_on(id: "best_#{second_answer.id}")

      expect(top_answer).to have_content second_answer.body
    end

    scenario 'user tries mark the best answer for not his question' do
      sign_in(users.last)
      visit question_path(question)

      expect(page).to_not have_link(id: "best_#{answer.id}")
    end

    scenario 'Unauthenticated user tries to mark the best answer' do
      visit question_path(question)

      expect(page).to_not have_link(id: "best_#{answer.id}")
    end
  end
end
