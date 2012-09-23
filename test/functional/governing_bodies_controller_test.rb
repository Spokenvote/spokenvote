require 'test_helper'

class GoverningBodiesControllerTest < ActionController::TestCase
  setup do
    @governing_body = governing_bodies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:governing_bodies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create governing_body" do
    assert_difference('GoverningBody.count') do
      post :create, governing_body: { description: @governing_body.description, location: @governing_body.location, name: @governing_body.name }
    end

    assert_redirected_to governing_body_path(assigns(:governing_body))
  end

  test "should show governing_body" do
    get :show, id: @governing_body
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @governing_body
    assert_response :success
  end

  test "should update governing_body" do
    put :update, id: @governing_body, governing_body: { description: @governing_body.description, location: @governing_body.location, name: @governing_body.name }
    assert_redirected_to governing_body_path(assigns(:governing_body))
  end

  test "should destroy governing_body" do
    assert_difference('GoverningBody.count', -1) do
      delete :destroy, id: @governing_body
    end

    assert_redirected_to governing_bodies_path
  end
end
