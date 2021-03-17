require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    context 'Authorized user creates comment with valid attributes' do
      before { login(user) }

      it 'saves a new comment to database' do
        expect do
          post :create, params: { comment: attributes_for(:comment), question_id: question },
                        format: :js
        end.to change(Comment, :count).by 1
      end

      it 'created by current user' do
        post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js

        expect(assigns(:comment).user).to eq user
      end
    end

    context 'Unauthorized user' do
      it 'tries to save a new comment to database' do
        expect do
          post :create, params: { comment: attributes_for(:comment),
                                  question_id: question }, format: :js
        end.to_not change(Comment, :count)
      end
    end
  end
end
