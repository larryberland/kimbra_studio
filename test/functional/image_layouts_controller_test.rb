require 'test_helper'

class ImageLayoutsControllerTest < ActionController::TestCase
  setup do
    @image_layout = image_layouts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:image_layouts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create image_layout" do
    assert_difference('ImageLayout.count') do
      post :create, image_layout: @image_layout.attributes
    end

    assert_redirected_to image_layout_path(assigns(:image_layout))
  end

  test "should show image_layout" do
    get :show, id: @image_layout.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @image_layout.to_param
    assert_response :success
  end

  test "should update image_layout" do
    put :update, id: @image_layout.to_param, image_layout: @image_layout.attributes
    assert_redirected_to image_layout_path(assigns(:image_layout))
  end

  test "should destroy image_layout" do
    assert_difference('ImageLayout.count', -1) do
      delete :destroy, id: @image_layout.to_param
    end

    assert_redirected_to image_layouts_path
  end
end
