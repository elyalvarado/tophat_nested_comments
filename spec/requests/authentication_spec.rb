require 'rails_helper'

RSpec.describe 'POST /api/sign_in', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:url) { '/api/sign_in' }
  let(:params) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end

  context 'when params are correct' do
    before do
      post url, params: params
    end

    it 'returns 200 OK' do
      expect(response).to have_http_status(200)
    end

    it 'returns JWT token in authorization header' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns a valid JWT token' do
      token_from_request = response.headers['Authorization'].split(' ').last
      jwt_secret_key = Rails.application.credentials.devise[:jwt_secret_key]
      decoded_token = JWT.decode(token_from_request, jwt_secret_key, true)

      expect(decoded_token.first['sub']).to be_present
    end

    it 'returns the user' do
      expect(response.body).to match_schema :user
    end
  end

  context 'when params are incorrect' do
    before { post url }

    it 'returns unauthorized status' do
      expect(response).to have_http_status(401)
    end
  end
end
