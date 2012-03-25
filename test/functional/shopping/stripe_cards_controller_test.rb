require 'test_helper'

class Shopping::StripeCardsControllerTest < ActionController::TestCase
  setup do
    @shopping_stripe_card = shopping_stripe_cards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shopping_stripe_cards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shopping_stripe_card" do
    assert_difference('Shopping::StripeCard.count') do
      post :create, shopping_stripe_card: @shopping_stripe_card.attributes
    end

    assert_redirected_to shopping_stripe_card_path(assigns(:shopping_stripe_card))
  end

  test "should show shopping_stripe_card" do
    get :show, id: @shopping_stripe_card.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @shopping_stripe_card.to_param
    assert_response :success
  end

  test "should update shopping_stripe_card" do
    put :update, id: @shopping_stripe_card.to_param, shopping_stripe_card: @shopping_stripe_card.attributes
    assert_redirected_to shopping_stripe_card_path(assigns(:shopping_stripe_card))
  end

  test "should destroy shopping_stripe_card" do
    assert_difference('Shopping::StripeCard.count', -1) do
      delete :destroy, id: @shopping_stripe_card.to_param
    end

    assert_redirected_to shopping_stripe_cards_path
  end
end
