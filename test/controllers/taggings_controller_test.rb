require "test_helper"

class TaggingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tagging = taggings(:one)
  end

  test "should get index" do
    get taggings_url, as: :json
    assert_response :success
  end

  test "should create tagging" do
    assert_difference("Tagging.count") do
      post taggings_url, params: { tagging: { post_id: @tagging.post_id, tag_id: @tagging.tag_id } }, as: :json
    end

    assert_response :created
  end

  test "should show tagging" do
    get tagging_url(@tagging), as: :json
    assert_response :success
  end

  test "should update tagging" do
    patch tagging_url(@tagging), params: { tagging: { post_id: @tagging.post_id, tag_id: @tagging.tag_id } }, as: :json
    assert_response :success
  end

  test "should destroy tagging" do
    assert_difference("Tagging.count", -1) do
      delete tagging_url(@tagging), as: :json
    end

    assert_response :no_content
  end
end
