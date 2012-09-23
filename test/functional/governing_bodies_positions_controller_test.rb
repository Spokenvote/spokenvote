require 'test_helper'

class GoverningBodiesPositionsControllerTest < ActionController::TestCase
  setup do
    @governing_bodies_position = governing_bodies_positions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:governing_bodies_positions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create governing_bodies_position" do
    assert_difference('GoverningBodiesPosition.count') do
      post :create, governing_bodies_position: {  }
    end

    assert_redirected_to governing_bodies_position_path(assigns(:governing_bodies_position))
  end

  test "should show governing_bodies_position" do
    get :show, id: @governing_bodies_position
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @governing_bodies_position
    assert_response :success
  end

  test "should update governing_bodies_position" do
    put :update, id: @governing_bodies_position, governing_bodies_position: {  }
    assert_redirected_to governing_bodies_position_path(assigns(:governing_bodies_position))
  end

  test "should destroy governing_bodies_position" do
    assert_difference('GoverningBodiesPosition.count', -1) do
      delete :destroy, id: @governing_bodies_position
    end

    assert_redirected_to governing_bodies_positions_path
  end
end
