class PostsController < ApplicationController
  before_action :set_post, only: %i[ show update destroy ]
  before_action :authorize_user!, only: %i[ update destroy ]

  # GET /posts
  def index
    @posts = Post.all

    render json: @posts
  end

  # GET /posts/1
  def show
    render json: @post
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    @post.user = @current_user
    if @post.save
      render json: { message: "Post created successfully" }, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      render json: { message: "Post updated successfully" }, status: :ok
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
   if  @post.destroy!
      render json: { message: "Post deleted successfully" }, status: :ok

   end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def authorize_user!
      render json: { error: "You are not authorized to perform this action" }, status: :forbidden unless @post.user == @current_user
    end
    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body, :tags)
    end
end
