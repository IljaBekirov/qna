require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:users) { create_list(:user, 2) }
  let!(:question) { create(:question, user: users.first) }
  let!(:reward) { create(:reward, question: question, user: users.first) }
  let(:answer) { create(:answer, question: question, user: users.first) }

  describe 'POST #create' do
    before { login(users.first) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }
          .to change(Answer, :count).by(1)
      end

      it 'render create view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question },
                      format: :js }
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

    context 'author' do
      before { login(users.first) }

      it 'delete the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }
          .to change(Answer, :count).by(-1)
      end

      it 'redirected to the question' do
        delete :destroy, params: { question_id: question, id: answer }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'not author' do
      before { login(users.last) }

      it 'answer is not deleted' do
        expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }.to change(Answer, :count).by(0)
      end
    end
  end

  describe 'PATCH #update' do
    context 'authenticated user is own answer' do
      before { login(users.first) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' }, question_id: question },
                format: :js

          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'redirect to updated question' do
          patch :update, params: { id: answer, answer: { body: 'new body' }, question_id: question },
                format: :js

          expect(response).to render_template :update
        end
      end

      context 'with not valid attribute' do
        it "doesn't change answer" do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question },
                format: :js

          answer.reload
          expect(answer.body).to eq answer.body
        end
      end

      context 'authenticated user trying to change another answer' do
        before { login(users.second) }

        it 'does not change answer' do
          expect { patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js }.to_not change(answer, :body)
        end

        it 'does not change answer' do
          answer.reload
          expect(answer.body).to eq answer.body
        end

        it 'renders show view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js

          expect(response).to render_template 'questions/show'
        end
      end
    end
  end

  describe 'PATCH #mark_as_best' do
    before { login(users.first) }

    it 'assign @answer' do
      patch :mark_as_best, params: { id: answer }, format: :js
      expect(assigns(:answer)).to eq(answer)
    end

    it 'author can choose best answer' do
      patch :mark_as_best, params: { id: answer }, format: :js

      answer.reload
      expect(answer).to eq answer.question.best_answer
    end
  end

  it_behaves_like 'voted'

  it_behaves_like 'commented' do
    let(:commented) { create(:answer, question: question, user: users.last) }
  end
end
