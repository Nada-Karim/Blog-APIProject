class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show update destroy ]
  before_action :authorize_user!, only: %i[ update destroy ]


  # GET /comments
  def index
    @comments = Comment.all

    render json: @comments
  end

  # GET /comments/1
  def show
    render json: @comment
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params)
    @comment.user = @current_user

    if @comment.save
      render json: { message: "Comment created successfully" }, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      render json: { message: "Comment updated successfully" }, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
   if  @comment.destroy!
      render json: { message: "Comment deleted successfully" }, status: :ok
   end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def authorize_user!
      render json: { error: "You are not authorized to perform this action" }, status: :forbidden unless @comment.user == @current_user
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:body, :post_id)
    end
end
