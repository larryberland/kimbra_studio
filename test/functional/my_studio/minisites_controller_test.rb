require 'test_helper'

class MyStudio::MinisitesControllerTest < ActionController::TestCase
  setup do
    @my_studio_minisite = my_studio_minisites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:my_studio_minisites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create my_studio_minisite" do
    assert_difference('MyStudio::Minisite.count') do
      post :create, my_studio_minisite: @my_studio_minisite.attributes
    end

    assert_redirected_to my_studio_minisite_path(assigns(:my_studio_minisite))
  end

  test "should show my_studio_minisite" do
    get :show, id: @my_studio_minisite.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @my_studio_minisite.to_param
    assert_response :success
  end

  test "should update my_studio_minisite" do
    put :update, id: @my_studio_minisite.to_param, my_studio_minisite: @my_studio_minisite.attributes
    assert_redirected_to my_studio_minisite_path(assigns(:my_studio_minisite))
  end

  test "should destroy my_studio_minisite" do
    assert_difference('MyStudio::Minisite.count', -1) do
      delete :destroy, id: @my_studio_minisite.to_param
    end

    assert_redirected_to my_studio_minisites_path
  end
end
