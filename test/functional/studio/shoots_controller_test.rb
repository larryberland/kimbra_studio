require 'test_helper'

class Studio::ShootsControllerTest < ActionController::TestCase
  setup do
    @studio_shoot = studio_shoots(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:studio_shoots)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create studio_shoot" do
    assert_difference('Studio::Shoot.count') do
      post :create, studio_shoot: @studio_shoot.attributes
    end

    assert_redirected_to studio_shoot_path(assigns(:studio_shoot))
  end

  test "should show studio_shoot" do
    get :show, id: @studio_shoot.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @studio_shoot.to_param
    assert_response :success
  end

  test "should update studio_shoot" do
    put :update, id: @studio_shoot.to_param, studio_shoot: @studio_shoot.attributes
    assert_redirected_to studio_shoot_path(assigns(:studio_shoot))
  end

  test "should destroy studio_shoot" do
    assert_difference('Studio::Shoot.count', -1) do
      delete :destroy, id: @studio_shoot.to_param
    end

    assert_redirected_to studio_shoots_path
  end
end
