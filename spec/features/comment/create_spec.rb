require 'rails_helper'

feature 'User can add comment' do
  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users.first) }
  given!(:answer) { create(:answer, question: question, user: users.first) }

  describe 'Auth user', js: true do
    background do
      sign_in(users.last)
      visit question_path(question)
    end

    scenario 'question' do
      fill_in id: 'comment_body', with: 'New comment'
      click_on 'Add comment'

      expect(page).to have_content 'New comment'
    end
  end

  describe 'multisessions ' do
    scenario 'comment added from other user page', js: true do
      Capybara.using_session('user') do
        sign_in(users.first)
        visit question_path(question)
      end

      Capybara.using_session('another_user') do
        sign_in(users.last)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in id: 'comment_body', with: 'New comment'
        click_on 'Add comment'

        expect(page).to have_content 'New comment'
      end

      Capybara.using_session('another_user') do
        expect(page).to have_content('New comment').once
      end
    end
  end

  describe 'Unauthorized user can`t add comment' do
    scenario 'and don`t see any button' do
      visit question_path(question)
      expect(page).to have_no_link 'Add comment'
    end
  end
end
