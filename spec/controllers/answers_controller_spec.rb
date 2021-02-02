require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:users) { create_list(:user, 2) }
  let!(:question) { create(:question, user: users.first) }
  let(:answer) { create(:answer, question: question, user: users.first) }

  describe 'POST #create' do
    before { login(users.first) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }
          .to change(Answer, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }
          .to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: users.first) }

    before { login(users.first) }

    it 'delete the answer' do
      expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirected to the question' do
      delete :destroy, params: { question_id: question, id: answer }

      expect(response).to redirect_to question_path(question)
    end
  end

  describe 'PATCH #update' do
    context 'authenticated user is own answer' do
      before { login(users.first) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' }, question_id: question }

          expect(flash[:notice]).to eq 'Your answer is updated'
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'redirect to updated question' do
          patch :update, params: { id: answer, answer: { body: 'new body' }, question_id: question }

          expect(response).to redirect_to question_path(answer.question)
        end
      end

      context 'with not valid attribute' do
        it "doesn't change answer" do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question }

          expect(flash[:error]).to eq 'Answer is not updated'
          answer.reload
          expect(answer.body).to eq answer.body
        end
      end

      context 'authenticated user trying to change another answer' do
        before do
          login(users.second)
          patch :update, params: { id: answer, answer: { body: 'new body' }, question_id: question }
        end

        it 'does not change answer' do
          answer.reload
          expect(answer.body).to eq answer.body
        end

        it 're-renders edit view' do
          expect(flash[:error]).to eq 'You are not author of this answer'
        end
      end
    end
  end
end
