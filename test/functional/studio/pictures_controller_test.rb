require 'test_helper'

class Studio::PicturesControllerTest < ActionController::TestCase
  setup do
    @studio_picture = studio_pictures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:studio_pictures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create studio_picture" do
    assert_difference('Studio::Picture.count') do
      post :create, studio_picture: @studio_picture.attributes
    end

    assert_redirected_to studio_picture_path(assigns(:studio_picture))
  end

  test "should show studio_picture" do
    get :show, id: @studio_picture.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @studio_picture.to_param
    assert_response :success
  end

  test "should update studio_picture" do
    put :update, id: @studio_picture.to_param, studio_picture: @studio_picture.attributes
    assert_redirected_to studio_picture_path(assigns(:studio_picture))
  end

  test "should destroy studio_picture" do
    assert_difference('Studio::Picture.count', -1) do
      delete :destroy, id: @studio_picture.to_param
    end

    assert_redirected_to studio_pictures_path
  end
end
