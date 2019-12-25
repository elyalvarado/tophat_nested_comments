require 'rails_helper'

RSpec.describe 'registration routes', type: :routing do
  it "routes POST /api/sign_up to registrations#create" do
    expect(post("/api/sign_up")).to route_to "registrations#create"
  end

  it "generates the user_registration helper" do
    expect(post(user_registration_path)).to route_to "registrations#create"
  end
end
