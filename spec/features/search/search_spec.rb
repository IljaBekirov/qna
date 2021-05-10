require 'sphinx_helper'

feature 'Search by ' do
  given!(:questions) { create_list(:question, 3, title: 'tests questions gmail') }
  given!(:answers) { create_list(:answer, 2, body: 'answers for questions gmail') }
  given!(:comments) { create_list(:comment, 2, body: 'comments for questions gmail', commentable: questions[0]) }
  given!(:user) { create(:user, email: 'admin@gmail.com') }

  shared_examples_for 'Search' do |query, times, type|
    scenario "by #{type}" do
      ThinkingSphinx::Test.run do
        visit root_path
        fill_in 'query', with: query
        click_on 'Search'

        expect(page).to have_content(query).exactly(times).times
      end
    end
  end

  context 'all categories', sphinx: true do
    it_should_behave_like 'Search', 'gmail', 8, 'all_categories'
  end

  context 'questions', sphinx: true do
    it_should_behave_like 'Search', 'tests', 3, 'questions'
  end

  context 'answers', sphinx: true do
    it_should_behave_like 'Search', 'answers', 2, 'answers'
  end

  context 'comments', sphinx: true do
    it_should_behave_like 'Search', 'comments', 2, 'comments'
  end

  context 'users', sphinx: true do
    it_should_behave_like 'Search', 'admin', 1, 'users'
  end
end
