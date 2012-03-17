require 'test_helper'

class Shopping::ItemsControllerTest < ActionController::TestCase
  setup do
    @shopping_item = shopping_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shopping_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shopping_item" do
    assert_difference('Shopping::Item.count') do
      post :create, shopping_item: @shopping_item.attributes
    end

    assert_redirected_to shopping_item_path(assigns(:shopping_item))
  end

  test "should show shopping_item" do
    get :show, id: @shopping_item.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @shopping_item.to_param
    assert_response :success
  end

  test "should update shopping_item" do
    put :update, id: @shopping_item.to_param, shopping_item: @shopping_item.attributes
    assert_redirected_to shopping_item_path(assigns(:shopping_item))
  end

  test "should destroy shopping_item" do
    assert_difference('Shopping::Item.count', -1) do
      delete :destroy, id: @shopping_item.to_param
    end

    assert_redirected_to shopping_items_path
  end
end
