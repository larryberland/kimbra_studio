require 'test_helper'

class Shopping::AddressesControllerTest < ActionController::TestCase
  setup do
    @shopping_address = shopping_addresses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shopping_addresses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shopping_address" do
    assert_difference('Shopping::Address.count') do
      post :create, shopping_address: @shopping_address.attributes
    end

    assert_redirected_to shopping_address_path(assigns(:shopping_address))
  end

  test "should show shopping_address" do
    get :show, id: @shopping_address.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @shopping_address.to_param
    assert_response :success
  end

  test "should update shopping_address" do
    put :update, id: @shopping_address.to_param, shopping_address: @shopping_address.attributes
    assert_redirected_to shopping_address_path(assigns(:shopping_address))
  end

  test "should destroy shopping_address" do
    assert_difference('Shopping::Address.count', -1) do
      delete :destroy, id: @shopping_address.to_param
    end

    assert_redirected_to shopping_addresses_path
  end
end
