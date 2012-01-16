require 'test_helper'

class Admin::OverviewsControllerTest < ActionController::TestCase
  setup do
    @admin_overview = admin_overviews(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_overviews)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_overview" do
    assert_difference('Admin::Overview.count') do
      post :create, admin_overview: @admin_overview.attributes
    end

    assert_redirected_to admin_overview_path(assigns(:admin_overview))
  end

  test "should show admin_overview" do
    get :show, id: @admin_overview.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_overview.to_param
    assert_response :success
  end

  test "should update admin_overview" do
    put :update, id: @admin_overview.to_param, admin_overview: @admin_overview.attributes
    assert_redirected_to admin_overview_path(assigns(:admin_overview))
  end

  test "should destroy admin_overview" do
    assert_difference('Admin::Overview.count', -1) do
      delete :destroy, id: @admin_overview.to_param
    end

    assert_redirected_to admin_overviews_path
  end
end
