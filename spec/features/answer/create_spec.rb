require 'rails_helper'

feature 'User can create answer' do
  given(:users) { create_list(:user, 2) }
  given(:question) { create(:question, user: users.first) }

  describe 'Authenticated user' do
    background do
      sign_in(users.first)
      visit question_path(question)
    end

    scenario 'answer the question', js: true  do
      fill_in 'Body', with: 'Answer a question'
      click_on 'Answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Answer a question'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'answer the question with error', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answer with attached files', js: true do
      fill_in 'Body', with: 'Answer for question'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'multisessions ' do
    scenario 'added answer from other user', js: true do
      Capybara.using_session('user') do
        sign_in(users.first)
        visit question_path(question)
      end

      Capybara.using_session('another_user') do
        sign_in(users.last)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'Answer for question'
        click_on 'Answer'

        expect(page).to have_content 'Your answer successfully created.'
        expect(page).to have_content 'Answer for question'
      end

      Capybara.using_session('another_user') do
        expect(page).to have_content 'Answer for question'
        expect(page).to have_no_link 'Edit'
        expect(page).to have_no_link 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user tries to answer the question', js: true do
    visit question_path(question)

    expect(page).to have_no_content 'Answer'
  end
end
