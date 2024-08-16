class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: %i[ show update destroy ]
  before_action :authorize_user!, only: %i[ update destroy ]

  # GET /posts/:post_id/comments
  def index
    @comments = @post.comments
    render json: @comments
  end

  # GET /posts/:post_id/comments/1
  def show
    render json: @comment
  end

  # POST /posts/:post_id/comments
  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = @current_user

    if @comment.save
      render json: { message: "Comment created successfully" }, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/:post_id/comments/1
  def update
    if @comment.update(comment_params)
      render json: { message: "Comment updated successfully" }, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/:post_id/comments/1
  def destroy
    if @comment.destroy!
      render json: { message: "Comment deleted successfully" }, status: :ok
    end
  end

  private

    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_comment
      @comment = @post.comments.find(params[:id])
    end

    def authorize_user!
      render json: { error: "You are not authorized to perform this action" }, status: :forbidden unless @comment.user == @current_user
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
end
