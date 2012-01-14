require 'test_helper'

class MyStudio::PortraitsControllerTest < ActionController::TestCase
  setup do
    @my_studio_portrait = my_studio_portraits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:my_studio_portraits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create my_studio_portrait" do
    assert_difference('MyStudio::Portrait.count') do
      post :create, my_studio_portrait: @my_studio_portrait.attributes
    end

    assert_redirected_to my_studio_portrait_path(assigns(:my_studio_portrait))
  end

  test "should show my_studio_portrait" do
    get :show, id: @my_studio_portrait.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @my_studio_portrait.to_param
    assert_response :success
  end

  test "should update my_studio_portrait" do
    put :update, id: @my_studio_portrait.to_param, my_studio_portrait: @my_studio_portrait.attributes
    assert_redirected_to my_studio_portrait_path(assigns(:my_studio_portrait))
  end

  test "should destroy my_studio_portrait" do
    assert_difference('MyStudio::Portrait.count', -1) do
      delete :destroy, id: @my_studio_portrait.to_param
    end

    assert_redirected_to my_studio_portraits_path
  end
end
