require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:reward) { create(:reward, question: question, user: user) }

  describe 'GET #index' do
    before do
      login(user)
      get :index
    end

    it 'assigns rewards equal for user rewards' do
      expect(assigns(:rewards)).to eq user.rewards
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
