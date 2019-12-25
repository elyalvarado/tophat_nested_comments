require 'rails_helper'

RSpec.describe 'authentication routes', type: :routing do
  it 'routes POST /api/sign_in to sessions#create' do
    expect(post('/api/sign_in')).to route_to 'sessions#create'
  end

  it 'generates the user_session helper' do
    expect(post(user_session_path)).to route_to 'sessions#create'
  end
end
