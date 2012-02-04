require 'test_helper'

class Minisite::ShowroomsControllerTest < ActionController::TestCase
  setup do
    @minisite_showroom = minisite_showrooms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:minisite_showrooms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create minisite_showroom" do
    assert_difference('Minisite::Showroom.count') do
      post :create, minisite_showroom: @minisite_showroom.attributes
    end

    assert_redirected_to minisite_showroom_path(assigns(:minisite_showroom))
  end

  test "should show minisite_showroom" do
    get :show, id: @minisite_showroom.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @minisite_showroom.to_param
    assert_response :success
  end

  test "should update minisite_showroom" do
    put :update, id: @minisite_showroom.to_param, minisite_showroom: @minisite_showroom.attributes
    assert_redirected_to minisite_showroom_path(assigns(:minisite_showroom))
  end

  test "should destroy minisite_showroom" do
    assert_difference('Minisite::Showroom.count', -1) do
      delete :destroy, id: @minisite_showroom.to_param
    end

    assert_redirected_to minisite_showrooms_path
  end
end
