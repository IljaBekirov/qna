require 'rails_helper'

feature 'User can edit his question' do
  given!(:file_blob) do
    ActiveStorage::Blob.create_and_upload! io: file_fixture("test.jpg").open,
                                           filename: "test.jpg",
                                           content_type: "image/jpeg",
                                           metadata: nil
  end
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

    scenario 'edit a question with attached files' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Update'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'edit a question for delete attached files', js: true do
      question.files.attach(file_blob)
      visit edit_question_path(question)
      click_on(id: "delete_file_#{question.files.first.id}")
      page.accept_alert

      expect(page).to have_no_link question.files.first.filename.to_s
    end
  end

  scenario 'Unauthenticated can not edit question' do
    sign_in(users.last)
    visit edit_question_path(question)

    expect(page).to_not have_link 'Update'
  end
end
