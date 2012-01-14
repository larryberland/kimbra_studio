require 'test_helper'

class MyStudio::SessionsControllerTest < ActionController::TestCase
  setup do
    @my_studio_session = my_studio_sessions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:my_studio_sessions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create my_studio_session" do
    assert_difference('MyStudio::Session.count') do
      post :create, my_studio_session: @my_studio_session.attributes
    end

    assert_redirected_to my_studio_session_path(assigns(:my_studio_session))
  end

  test "should show my_studio_session" do
    get :show, id: @my_studio_session.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @my_studio_session.to_param
    assert_response :success
  end

  test "should update my_studio_session" do
    put :update, id: @my_studio_session.to_param, my_studio_session: @my_studio_session.attributes
    assert_redirected_to my_studio_session_path(assigns(:my_studio_session))
  end

  test "should destroy my_studio_session" do
    assert_difference('MyStudio::Session.count', -1) do
      delete :destroy, id: @my_studio_session.to_param
    end

    assert_redirected_to my_studio_sessions_path
  end
end
