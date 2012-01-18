require 'test_helper'

class Admin::Merchandise::PartsControllerTest < ActionController::TestCase
  setup do
    @admin_merchandise_part = admin_merchandise_parts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_merchandise_parts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_merchandise_part" do
    assert_difference('Admin::Merchandise::Part.count') do
      post :create, admin_merchandise_part: @admin_merchandise_part.attributes
    end

    assert_redirected_to admin_merchandise_part_path(assigns(:admin_merchandise_part))
  end

  test "should show admin_merchandise_part" do
    get :show, id: @admin_merchandise_part.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_merchandise_part.to_param
    assert_response :success
  end

  test "should update admin_merchandise_part" do
    put :update, id: @admin_merchandise_part.to_param, admin_merchandise_part: @admin_merchandise_part.attributes
    assert_redirected_to admin_merchandise_part_path(assigns(:admin_merchandise_part))
  end

  test "should destroy admin_merchandise_part" do
    assert_difference('Admin::Merchandise::Part.count', -1) do
      delete :destroy, id: @admin_merchandise_part.to_param
    end

    assert_redirected_to admin_merchandise_parts_path
  end
end
