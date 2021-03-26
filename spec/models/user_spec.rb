require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:rewards) }
  it { should have_many(:votes) }

  describe '.find_for_auth' do
    let!(:user) { create(:user) }
    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations
      end
    end
  end
end
