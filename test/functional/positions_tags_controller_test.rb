require 'test_helper'

class PositionsTagsControllerTest < ActionController::TestCase
  setup do
    @positions_tag = positions_tags(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:positions_tags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create positions_tag" do
    assert_difference('PositionsTag.count') do
      post :create, positions_tag: {  }
    end

    assert_redirected_to positions_tag_path(assigns(:positions_tag))
  end

  test "should show positions_tag" do
    get :show, id: @positions_tag
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @positions_tag
    assert_response :success
  end

  test "should update positions_tag" do
    put :update, id: @positions_tag, positions_tag: {  }
    assert_redirected_to positions_tag_path(assigns(:positions_tag))
  end

  test "should destroy positions_tag" do
    assert_difference('PositionsTag.count', -1) do
      delete :destroy, id: @positions_tag
    end

    assert_redirected_to positions_tags_path
  end
end
