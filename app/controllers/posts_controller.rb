class PostsController < ApplicationController
  before_action :set_post, only: %i[ show update destroy ]
  before_action :authorize_user!, only: %i[ update destroy ]

  # GET /posts
  def index
    @posts = Post.all.includes(:tags)

    render json: @posts.to_json(include: :tags)
  end

  # GET /posts/1
  def show
    render json: @post.to_json(include: :tags)
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    @post.user = @current_user

    if params[:tags].blank?
      render json: { error: "At least one tag is required" }, status: :unprocessable_entity
      return
    end

    if @post.save
      attach_tags
      render json: { message: "Post created successfully" }, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  #
  def update
    if @post.update(post_params)
      @post.taggings.destroy_all  # Clear existing tags

      if params[:tags].blank?
        render json: { error: "At least one tag is required" }, status: :unprocessable_entity
        return
      end
      attach_tags  # Attach new tags
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
      params.require(:post).permit(:title, :body)
    end

    def attach_tags
      if params[:tags].present?
        Rails.logger.debug("Tags: #{params[:tags]}")
        params[:tags].each do |tag_name|
          tag = Tag.find_or_create_by(name: tag_name)
          @post.tags << tag unless @post.tags.include?(tag)
        end
      end
    end
end
