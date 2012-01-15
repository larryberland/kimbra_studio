require 'test_helper'

class MyStudio::InfosControllerTest < ActionController::TestCase
  setup do
    @my_studio_info = my_studio_infos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:my_studio_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create my_studio_info" do
    assert_difference('MyStudio::Info.count') do
      post :create, my_studio_info: @my_studio_info.attributes
    end

    assert_redirected_to my_studio_info_path(assigns(:my_studio_info))
  end

  test "should show my_studio_info" do
    get :show, id: @my_studio_info.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @my_studio_info.to_param
    assert_response :success
  end

  test "should update my_studio_info" do
    put :update, id: @my_studio_info.to_param, my_studio_info: @my_studio_info.attributes
    assert_redirected_to my_studio_info_path(assigns(:my_studio_info))
  end

  test "should destroy my_studio_info" do
    assert_difference('MyStudio::Info.count', -1) do
      delete :destroy, id: @my_studio_info.to_param
    end

    assert_redirected_to my_studio_infos_path
  end
end
