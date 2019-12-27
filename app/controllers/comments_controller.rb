class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :create

  # GET /comments
  def index
    @comments = Comment.all

    render json: @comments
  end

  # POST /comments
  def create
    @comment = current_user.comments.build(comment_params)

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private
  # Only allow a trusted parameter "white list" through.
  def comment_params
    params.require(:comment).permit(:parent_id, :content)
  end
end
