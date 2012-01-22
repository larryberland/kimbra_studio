require 'test_helper'

class MyStudio::Portrait::FacesControllerTest < ActionController::TestCase
  setup do
    @my_studio_portrait_face = my_studio_portrait_faces(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:my_studio_portrait_faces)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create my_studio_portrait_face" do
    assert_difference('MyStudio::Portrait::Face.count') do
      post :create, my_studio_portrait_face: @my_studio_portrait_face.attributes
    end

    assert_redirected_to my_studio_portrait_face_path(assigns(:my_studio_portrait_face))
  end

  test "should show my_studio_portrait_face" do
    get :show, id: @my_studio_portrait_face.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @my_studio_portrait_face.to_param
    assert_response :success
  end

  test "should update my_studio_portrait_face" do
    put :update, id: @my_studio_portrait_face.to_param, my_studio_portrait_face: @my_studio_portrait_face.attributes
    assert_redirected_to my_studio_portrait_face_path(assigns(:my_studio_portrait_face))
  end

  test "should destroy my_studio_portrait_face" do
    assert_difference('MyStudio::Portrait::Face.count', -1) do
      delete :destroy, id: @my_studio_portrait_face.to_param
    end

    assert_redirected_to my_studio_portrait_faces_path
  end
end
