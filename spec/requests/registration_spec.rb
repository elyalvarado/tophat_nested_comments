require 'rails_helper'

RSpec.describe 'POST /api/sign_up', type: :request do
  let(:url) { '/api/sign_up' }
  let(:params) do
    {
      user: {
        email: 'test@example.com',
        password: 'password'
      }
    }
  end

  context 'when user is unauthenticated' do
    before { post url, params: params }

    it 'returns 200 OK' do
      expect(response).to have_http_status(200)
    end

    it 'returns a new user' do
      expect(response.body).to match_schema(:user)
    end
  end

  context 'when user already exists' do
    before do
      FactoryBot.create(:user, email: params[:user][:email])
      post url, params: params
    end

    it 'returns a bad request status' do
      expect(response).to have_http_status(400)
    end
  end
end
