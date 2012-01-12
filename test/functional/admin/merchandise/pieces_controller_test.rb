require 'test_helper'

class Admin::Merchandise::PiecesControllerTest < ActionController::TestCase
  setup do
    @admin_merchandise_piece = admin_merchandise_pieces(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_merchandise_pieces)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_merchandise_piece" do
    assert_difference('Admin::Merchandise::Piece.count') do
      post :create, admin_merchandise_piece: @admin_merchandise_piece.attributes
    end

    assert_redirected_to admin_merchandise_piece_path(assigns(:admin_merchandise_piece))
  end

  test "should show admin_merchandise_piece" do
    get :show, id: @admin_merchandise_piece.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_merchandise_piece.to_param
    assert_response :success
  end

  test "should update admin_merchandise_piece" do
    put :update, id: @admin_merchandise_piece.to_param, admin_merchandise_piece: @admin_merchandise_piece.attributes
    assert_redirected_to admin_merchandise_piece_path(assigns(:admin_merchandise_piece))
  end

  test "should destroy admin_merchandise_piece" do
    assert_difference('Admin::Merchandise::Piece.count', -1) do
      delete :destroy, id: @admin_merchandise_piece.to_param
    end

    assert_redirected_to admin_merchandise_pieces_path
  end
end
