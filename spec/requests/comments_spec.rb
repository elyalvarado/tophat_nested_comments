require 'rails_helper'

RSpec.describe CommentsController, type: :request do

  let(:valid_attributes) { FactoryBot.attributes_for(:comment) }

  let(:invalid_attributes) { FactoryBot.attributes_for(:comment, :invalid) }

  context 'without authentication' do
    describe "POST #create" do
      it 'should return with a unauthorized status' do
        post '/api/comments', params: { comment: valid_attributes }
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "GET #index" do
    it "returns a success response" do
      get '/api/comments'
      expect(response).to be_successful
    end

    it "returns all existing comments" do
      comments = FactoryBot.create_list(:comment, 3)
      get '/api/comments'
      expect(response.body).to eq(comments.to_json)
    end

    xit 'returns only top level comments with nested children'
  end

  describe "POST #create" do
    let(:user) { FactoryBot.create(:user) }
    let(:auth_headers) { jwt_auth_headers_for(user) }

    context "with valid params" do
      it "creates a new Comment" do
        expect {
          post '/api/comments', params: { comment: valid_attributes }, headers: auth_headers
        }.to change(Comment, :count).by(1)
      end

      it 'the created comment should belong to the authenticated user' do
        post '/api/comments', params: { comment: valid_attributes }, headers: auth_headers
        expect(Comment.last.user).to eq(user)
      end

      it "renders a JSON response with the new comment" do
        post '/api/comments', params: { comment: valid_attributes }, headers: auth_headers
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(/^application\/json/)
        expect(response.body).to eq(Comment.last.to_json)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new comment" do
        post '/api/comments', params: { comment: invalid_attributes }, headers: auth_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(/^application\/json/)
      end
    end
  end
end
