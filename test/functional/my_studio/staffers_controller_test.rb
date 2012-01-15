require 'test_helper'

class MyStudio::StaffersControllerTest < ActionController::TestCase
  setup do
    @my_studio_staffer = my_studio_staffers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:my_studio_staffers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create my_studio_staffer" do
    assert_difference('MyStudio::Staffer.count') do
      post :create, my_studio_staffer: @my_studio_staffer.attributes
    end

    assert_redirected_to my_studio_staffer_path(assigns(:my_studio_staffer))
  end

  test "should show my_studio_staffer" do
    get :show, id: @my_studio_staffer.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @my_studio_staffer.to_param
    assert_response :success
  end

  test "should update my_studio_staffer" do
    put :update, id: @my_studio_staffer.to_param, my_studio_staffer: @my_studio_staffer.attributes
    assert_redirected_to my_studio_staffer_path(assigns(:my_studio_staffer))
  end

  test "should destroy my_studio_staffer" do
    assert_difference('MyStudio::Staffer.count', -1) do
      delete :destroy, id: @my_studio_staffer.to_param
    end

    assert_redirected_to my_studio_staffers_path
  end
end
