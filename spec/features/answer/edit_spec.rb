require 'rails_helper'

feature 'User can edit his answer' do
  given!(:file_blob) do
    ActiveStorage::Blob.create_and_upload! io: file_fixture('test.jpg').open,
                                           filename: 'test.jpg',
                                           content_type: 'image/jpeg',
                                           metadata: nil
  end
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
        answer.files.attach(file_blob)
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

      scenario 'edit the answer with add files', js: true do
        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'
          attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'edit the answer and delete files', js: true do
        within '.answers' do
          click_on(id: "delete_file_#{answer.files.first.id}")
          page.accept_alert

          expect(page).to have_no_link answer.files.first.filename.to_s
        end
      end
    end

    scenario "tries to edit other user's question" do
      sign_in(users.last)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end
