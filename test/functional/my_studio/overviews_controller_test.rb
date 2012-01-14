require 'test_helper'

class MyStudio::OverviewsControllerTest < ActionController::TestCase
  setup do
    @my_studio_overview = my_studio_overviews(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:my_studio_overviews)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create my_studio_overview" do
    assert_difference('MyStudio::Overview.count') do
      post :create, my_studio_overview: @my_studio_overview.attributes
    end

    assert_redirected_to my_studio_overview_path(assigns(:my_studio_overview))
  end

  test "should show my_studio_overview" do
    get :show, id: @my_studio_overview.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @my_studio_overview.to_param
    assert_response :success
  end

  test "should update my_studio_overview" do
    put :update, id: @my_studio_overview.to_param, my_studio_overview: @my_studio_overview.attributes
    assert_redirected_to my_studio_overview_path(assigns(:my_studio_overview))
  end

  test "should destroy my_studio_overview" do
    assert_difference('MyStudio::Overview.count', -1) do
      delete :destroy, id: @my_studio_overview.to_param
    end

    assert_redirected_to my_studio_overviews_path
  end
end
