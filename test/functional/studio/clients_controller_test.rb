require 'test_helper'

class Studio::ClientsControllerTest < ActionController::TestCase
  setup do
    @studio_client = studio_clients(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:studio_clients)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create studio_client" do
    assert_difference('Studio::Client.count') do
      post :create, studio_client: @studio_client.attributes
    end

    assert_redirected_to studio_client_path(assigns(:studio_client))
  end

  test "should show studio_client" do
    get :show, id: @studio_client.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @studio_client.to_param
    assert_response :success
  end

  test "should update studio_client" do
    put :update, id: @studio_client.to_param, studio_client: @studio_client.attributes
    assert_redirected_to studio_client_path(assigns(:studio_client))
  end

  test "should destroy studio_client" do
    assert_difference('Studio::Client.count', -1) do
      delete :destroy, id: @studio_client.to_param
    end

    assert_redirected_to studio_clients_path
  end
end
