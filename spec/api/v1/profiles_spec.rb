require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }

      before do
        do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
      end

      it_behaves_like 'Request successful'

      it_behaves_like 'Public fields' do
        let(:attrs) { %w[id email admin created_at updated_at] }
        let(:resource_response) { json['user'] }
        let(:resource) { me }
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:users) { create_list(:user, 3) }
      let(:me) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
      end

      it_behaves_like 'Request successful'

      it 'returns list of users without one' do
        expect(json['users'].size).to eq(users.size - 1)
      end

      it 'does not return me' do
        expect(json['users'].map(&:user['id'])).to_not include(me.id)
      end

      it_behaves_like 'Public fields' do
        let(:attrs) { %w[id email admin created_at updated_at] }
        let(:resource_response) { json['users'].last }
        let(:resource) { users.last }
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end
end
