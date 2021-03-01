require 'rails_helper'

feature 'User can vote for a question' do
  given(:author) { create(:user) }
  given(:voter) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'User is not an author of question', js: true do
    background do
      sign_in(voter)
      visit questions_path
    end

    scenario 'votes up for question' do
      within "#question_#{question.id}" do
        find(:css, 'i.fas.fa-caret-up').click

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'tries to vote up for question twice' do
      within "#question_#{question.id}" do
        find(:css, 'i.fas.fa-caret-up').click
        find(:css, 'i.fas.fa-caret-up').click

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'cancels his vote' do
      within "#question_#{question.id}" do
        find(:css, 'i.fas.fa-caret-up').click
        click_on 'cancel'

        within '.rating' do
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'votes down for question' do
      within "#question_#{question.id}" do
        find(:css, 'i.fas.fa-caret-down').click

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'tries to vote down for question twice' do
      within "#question_#{question.id}" do
        find(:css, 'i.fas.fa-caret-down').click
        find(:css, 'i.fas.fa-caret-down').click

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'can re-votes' do
      within "#question_#{question.id}" do
        find(:css, 'i.fas.fa-caret-up').click
        click_on 'cancel'
        find(:css, 'i.fas.fa-caret-down').click

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end
  end

  describe 'User is author of answer tries to', js: true do
    background do
      sign_in(author)
      visit questions_path
    end

    scenario 'vote up for his question' do
      expect(page).to_not have_selector '.vote-up'
    end

    scenario 'vote down for his question' do
      expect(page).to_not have_selector '.vote-down'
    end

    scenario 'cancel vote' do
      expect(page).to_not have_selector '.vote-cancel'
    end
  end

  describe 'Unauthorized user tries to' do
    background { visit questions_path }

    scenario 'vote up for question' do
      expect(page).to_not have_selector '.vote-up'
    end

    scenario 'vote down for question' do
      expect(page).to_not have_selector '.vote-down'
    end

    scenario 'cancel vote' do
      expect(page).to_not have_selector '.vote-cancel'
    end
  end
end
