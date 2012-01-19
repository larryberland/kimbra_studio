require 'test_helper'

class Admin::Customer::ItemsControllerTest < ActionController::TestCase
  setup do
    @admin_customer_item = admin_customer_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_customer_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_customer_item" do
    assert_difference('Admin::Customer::Item.count') do
      post :create, admin_customer_item: @admin_customer_item.attributes
    end

    assert_redirected_to admin_customer_item_path(assigns(:admin_customer_item))
  end

  test "should show admin_customer_item" do
    get :show, id: @admin_customer_item.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_customer_item.to_param
    assert_response :success
  end

  test "should update admin_customer_item" do
    put :update, id: @admin_customer_item.to_param, admin_customer_item: @admin_customer_item.attributes
    assert_redirected_to admin_customer_item_path(assigns(:admin_customer_item))
  end

  test "should destroy admin_customer_item" do
    assert_difference('Admin::Customer::Item.count', -1) do
      delete :destroy, id: @admin_customer_item.to_param
    end

    assert_redirected_to admin_customer_items_path
  end
end
