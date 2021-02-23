require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:users) { create_list(:user, 2) }
  let(:question) { create(:question, user: users.first) }
  let(:reward) { create(:reward, question: question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to render_template :show
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do
    before { login(users.first) }

    before { get :new }

    it 'assigns a new Question to @quetion' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Question to @quetion' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'assigns the reward to @question' do
      expect(assigns(:question).reward).to be_a_new(Reward)
    end
  end

  describe 'GET #edit' do
    before { login(users.first) }

    before { get :edit, params: { id: question } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(users.first) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }
          .to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(users.first) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }

        expect(flash[:notice]).to eq 'Your answer is updated'
        expect(assigns(:question)).to eq question
      end

      it 'change question attribute' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }

        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

      it 'does not change question' do
        expect(flash[:error]).to eq 'Question is not updated'
        question.reload

        expect(question.title).to eq 'Title of question'
        expect(question.body).to eq 'Body of question'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'with valid attributes' do
      before { login(users.last) }

      it 'tries update at another user' do
        patch :update, params: { id: question, question: attributes_for(:question) }

        expect(flash[:error]).to eq 'You are not author of this question'
        expect(response).to redirect_to questions_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }

    context 'own question' do
      before { login(question.user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }

        expect(flash[:notice]).to eq 'Your question successfully deleted!'
        expect(response).to redirect_to questions_path
      end
    end

    context "another's question" do
      before { login(users.last) }

      it 'show error flash and redirect to questions' do
        delete :destroy, params: { id: question }

        expect(flash[:error]).to eq 'You are not author of this question'
        expect(response).to redirect_to questions_path
      end
    end
  end
end
