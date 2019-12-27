require "rails_helper"

RSpec.describe CommentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/api/comments").to route_to("comments#index")
    end

    it "routes to #create" do
      expect(:post => "/api/comments").to route_to("comments#create")
    end
  end
end
