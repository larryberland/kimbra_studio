require 'test_helper'

class Shopping::PurchasesControllerTest < ActionController::TestCase
  setup do
    @shopping_purchase = shopping_purchases(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shopping_purchases)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shopping_purchase" do
    assert_difference('Shopping::Purchase.count') do
      post :create, shopping_purchase: @shopping_purchase.attributes
    end

    assert_redirected_to shopping_purchase_path(assigns(:shopping_purchase))
  end

  test "should show shopping_purchase" do
    get :show, id: @shopping_purchase.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @shopping_purchase.to_param
    assert_response :success
  end

  test "should update shopping_purchase" do
    put :update, id: @shopping_purchase.to_param, shopping_purchase: @shopping_purchase.attributes
    assert_redirected_to shopping_purchase_path(assigns(:shopping_purchase))
  end

  test "should destroy shopping_purchase" do
    assert_difference('Shopping::Purchase.count', -1) do
      delete :destroy, id: @shopping_purchase.to_param
    end

    assert_redirected_to shopping_purchases_path
  end
end
