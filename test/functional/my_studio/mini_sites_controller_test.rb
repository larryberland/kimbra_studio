require 'test_helper'

class MyStudio::MiniSitesControllerTest < ActionController::TestCase
  setup do
    @my_studio_mini_site = my_studio_mini_sites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:my_studio_mini_sites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create my_studio_mini_site" do
    assert_difference('MyStudio::MiniSite.count') do
      post :create, my_studio_mini_site: @my_studio_mini_site.attributes
    end

    assert_redirected_to my_studio_mini_site_path(assigns(:my_studio_mini_site))
  end

  test "should show my_studio_mini_site" do
    get :show, id: @my_studio_mini_site.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @my_studio_mini_site.to_param
    assert_response :success
  end

  test "should update my_studio_mini_site" do
    put :update, id: @my_studio_mini_site.to_param, my_studio_mini_site: @my_studio_mini_site.attributes
    assert_redirected_to my_studio_mini_site_path(assigns(:my_studio_mini_site))
  end

  test "should destroy my_studio_mini_site" do
    assert_difference('MyStudio::MiniSite.count', -1) do
      delete :destroy, id: @my_studio_mini_site.to_param
    end

    assert_redirected_to my_studio_mini_sites_path
  end
end
