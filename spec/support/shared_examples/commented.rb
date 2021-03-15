require 'rails_helper'

shared_examples 'commented' do
  context 'POST #add_comment' do
    before { login(users.first) }

    it 'create a new comment' do
      expect do
 post :add_comment,
      params: { id: commented, comment: { body: 'Test Commit' }, format: :js } end.to change(Comment, :count).by(1)
    end
  end
end
