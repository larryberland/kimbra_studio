require 'test_helper'

class Shopping::CartsControllerTest < ActionController::TestCase
  setup do
    @shopping_cart = shopping_carts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shopping_carts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shopping_cart" do
    assert_difference('Shopping::Cart.count') do
      post :create, shopping_cart: @shopping_cart.attributes
    end

    assert_redirected_to shopping_cart_path(assigns(:shopping_cart))
  end

  test "should show shopping_cart" do
    get :show, id: @shopping_cart.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @shopping_cart.to_param
    assert_response :success
  end

  test "should update shopping_cart" do
    put :update, id: @shopping_cart.to_param, shopping_cart: @shopping_cart.attributes
    assert_redirected_to shopping_cart_path(assigns(:shopping_cart))
  end

  test "should destroy shopping_cart" do
    assert_difference('Shopping::Cart.count', -1) do
      delete :destroy, id: @shopping_cart.to_param
    end

    assert_redirected_to shopping_carts_path
  end
end
