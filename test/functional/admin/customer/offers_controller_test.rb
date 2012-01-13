require 'test_helper'

class Admin::Customer::OffersControllerTest < ActionController::TestCase
  setup do
    @admin_customer_offer = admin_customer_offers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_customer_offers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_customer_offer" do
    assert_difference('Admin::Customer::Offer.count') do
      post :create, admin_customer_offer: @admin_customer_offer.attributes
    end

    assert_redirected_to admin_customer_offer_path(assigns(:admin_customer_offer))
  end

  test "should show admin_customer_offer" do
    get :show, id: @admin_customer_offer.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_customer_offer.to_param
    assert_response :success
  end

  test "should update admin_customer_offer" do
    put :update, id: @admin_customer_offer.to_param, admin_customer_offer: @admin_customer_offer.attributes
    assert_redirected_to admin_customer_offer_path(assigns(:admin_customer_offer))
  end

  test "should destroy admin_customer_offer" do
    assert_difference('Admin::Customer::Offer.count', -1) do
      delete :destroy, id: @admin_customer_offer.to_param
    end

    assert_redirected_to admin_customer_offers_path
  end
end
