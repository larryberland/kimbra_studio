require 'test_helper'

class Admin::Email::OffersControllerTest < ActionController::TestCase
  setup do
    @admin_email_offer = admin_email_offers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_email_offers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_email_offer" do
    assert_difference('Admin::Email::Offer.count') do
      post :create, admin_email_offer: @admin_email_offer.attributes
    end

    assert_redirected_to admin_email_offer_path(assigns(:admin_email_offer))
  end

  test "should show admin_email_offer" do
    get :show, id: @admin_email_offer.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_email_offer.to_param
    assert_response :success
  end

  test "should update admin_email_offer" do
    put :update, id: @admin_email_offer.to_param, admin_email_offer: @admin_email_offer.attributes
    assert_redirected_to admin_email_offer_path(assigns(:admin_email_offer))
  end

  test "should destroy admin_email_offer" do
    assert_difference('Admin::Email::Offer.count', -1) do
      delete :destroy, id: @admin_email_offer.to_param
    end

    assert_redirected_to admin_email_offers_path
  end
end
