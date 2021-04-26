require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:rewards) }
  it { should have_many(:votes) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe '.find_for_auth' do
    let!(:user) { create(:user) }
    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations
      end
    end
  end

  describe '#subscribed_of?' do
    let!(:user) { create(:user) }
    let(:user_not_sub) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:subscription) { create(:subscription, question: question, user: user) }

    it 'return true if user subscribed' do
      expect(user).to be_subscribed_of(question)
    end

    it 'return false if unsubscribed' do
      expect(user_not_sub).to_not be_subscribed_of(question)
    end
  end
end
