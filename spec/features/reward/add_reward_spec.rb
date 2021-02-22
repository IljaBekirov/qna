require 'rails_helper'

feature 'User can add reward for the best answer' do
  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users.first) }
  given!(:answer) { create(:answer, question: question, user: users.first) }
  given!(:other_answer) { create(:answer, question: question, user: users.last) }
  given!(:reward) { create(:reward, question: question, user: users.first) }

  background { sign_in(users.first) }

  scenario 'Author added the reward when create question' do
    visit new_question_path
    fill_in 'Title', with: 'Title'
    fill_in 'Body', with: 'Body'

    fill_in 'Title reward', with: 'Title reward'
    attach_file 'question[reward_attributes][image]', "#{Rails.root}/spec/fixtures/files/test.jpg"

    click_on 'Ask'

    expect(page).to have_content 'Title reward'
    expect(page).to have_content 'Your question successfully created.'
  end
end
