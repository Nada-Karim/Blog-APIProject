class TaggingsController < ApplicationController
  before_action :set_tagging, only: %i[ show update destroy ]

  # GET /taggings
  def index
    @taggings = Tagging.all

    render json: @taggings
  end

  # GET /taggings/1
  def show
    render json: @tagging
  end

  # POST /taggings
  def create
    @tagging = Tagging.new(tagging_params)

    if @tagging.save
      render json: @tagging, status: :created, location: @tagging
    else
      render json: @tagging.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /taggings/1
  def update
    if @tagging.update(tagging_params)
      render json: @tagging
    else
      render json: @tagging.errors, status: :unprocessable_entity
    end
  end

  # DELETE /taggings/1
  def destroy
    @tagging.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tagging
      @tagging = Tagging.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tagging_params
      params.require(:tagging).permit(:tag_id, :post_id)
    end
end
