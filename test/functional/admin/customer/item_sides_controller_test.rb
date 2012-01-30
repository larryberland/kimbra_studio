require 'test_helper'

class Admin::Customer::ItemSidesControllerTest < ActionController::TestCase
  setup do
    @admin_customer_item_side = admin_customer_item_sides(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_customer_item_sides)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_customer_item_side" do
    assert_difference('Admin::Customer::ItemSide.count') do
      post :create, admin_customer_item_side: @admin_customer_item_side.attributes
    end

    assert_redirected_to admin_customer_item_side_path(assigns(:admin_customer_item_side))
  end

  test "should show admin_customer_item_side" do
    get :show, id: @admin_customer_item_side.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_customer_item_side.to_param
    assert_response :success
  end

  test "should update admin_customer_item_side" do
    put :update, id: @admin_customer_item_side.to_param, admin_customer_item_side: @admin_customer_item_side.attributes
    assert_redirected_to admin_customer_item_side_path(assigns(:admin_customer_item_side))
  end

  test "should destroy admin_customer_item_side" do
    assert_difference('Admin::Customer::ItemSide.count', -1) do
      delete :destroy, id: @admin_customer_item_side.to_param
    end

    assert_redirected_to admin_customer_item_sides_path
  end
end
