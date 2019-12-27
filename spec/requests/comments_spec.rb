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

    it 'returns only top level comments' do
      comment = FactoryBot.create(:comment, parent_id: nil)
      FactoryBot.create_list(:comment, 2, parent_id: comment.id)
      get '/api/comments'
      root_comment_ids = JSON.parse(response.body).map { |c| c["id"] }
      expect(root_comment_ids).to eq [ comment.id ]
    end

    def root_tree structure
      structure.reduce({}) do |memo, comment|
        memo[comment["id"]] = tree_for(comment)
        memo
      end
    end

    def tree_for comment
      comment["children"]&.reduce({}) do |memo, child|
        memo[child["id"]] = tree_for(child)
        memo
      end
    end
    it 'returns comments with children nested' do
      top_level_comment = FactoryBot.create(:comment, parent_id: nil)
      another_top_level_comment = FactoryBot.create(:comment, parent_id: nil)
      mid_level_comment = FactoryBot.create(:comment, parent_id: top_level_comment.id)
      bottom_level_comment = FactoryBot.create(:comment, parent_id: mid_level_comment.id)
      get '/api/comments'
      all_comments = JSON.parse(response.body)
      expected_ids = {
        top_level_comment.id =>
          {
            mid_level_comment.id =>
              { bottom_level_comment.id => {} }
          },
        another_top_level_comment.id => {}
      }
      expect(root_tree(all_comments)).to eq expected_ids
    end
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
