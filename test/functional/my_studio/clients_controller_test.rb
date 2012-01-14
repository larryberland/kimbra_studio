require 'test_helper'

class MyStudio::ClientsControllerTest < ActionController::TestCase
  setup do
    @my_studio_client = my_studio_clients(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:my_studio_clients)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create my_studio_client" do
    assert_difference('MyStudio::Client.count') do
      post :create, my_studio_client: @my_studio_client.attributes
    end

    assert_redirected_to my_studio_client_path(assigns(:my_studio_client))
  end

  test "should show my_studio_client" do
    get :show, id: @my_studio_client.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @my_studio_client.to_param
    assert_response :success
  end

  test "should update my_studio_client" do
    put :update, id: @my_studio_client.to_param, my_studio_client: @my_studio_client.attributes
    assert_redirected_to my_studio_client_path(assigns(:my_studio_client))
  end

  test "should destroy my_studio_client" do
    assert_difference('MyStudio::Client.count', -1) do
      delete :destroy, id: @my_studio_client.to_param
    end

    assert_redirected_to my_studio_clients_path
  end
end
