require 'test_helper'

class MyStudio::DashboardsControllerTest < ActionController::TestCase
  setup do
    @my_studio_dashboard = my_studio_dashboards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:my_studio_dashboards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create my_studio_dashboard" do
    assert_difference('MyStudio::Dashboard.count') do
      post :create, my_studio_dashboard: @my_studio_dashboard.attributes
    end

    assert_redirected_to my_studio_dashboard_path(assigns(:my_studio_dashboard))
  end

  test "should show my_studio_dashboard" do
    get :show, id: @my_studio_dashboard.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @my_studio_dashboard.to_param
    assert_response :success
  end

  test "should update my_studio_dashboard" do
    put :update, id: @my_studio_dashboard.to_param, my_studio_dashboard: @my_studio_dashboard.attributes
    assert_redirected_to my_studio_dashboard_path(assigns(:my_studio_dashboard))
  end

  test "should destroy my_studio_dashboard" do
    assert_difference('MyStudio::Dashboard.count', -1) do
      delete :destroy, id: @my_studio_dashboard.to_param
    end

    assert_redirected_to my_studio_dashboards_path
  end
end
