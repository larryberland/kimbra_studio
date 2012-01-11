require 'test_helper'

class Studio::OverviewsControllerTest < ActionController::TestCase
  setup do
    @studio_overview = studio_overviews(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:studio_overviews)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create studio_overview" do
    assert_difference('Studio::Overview.count') do
      post :create, studio_overview: @studio_overview.attributes
    end

    assert_redirected_to studio_overview_path(assigns(:studio_overview))
  end

  test "should show studio_overview" do
    get :show, id: @studio_overview.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @studio_overview.to_param
    assert_response :success
  end

  test "should update studio_overview" do
    put :update, id: @studio_overview.to_param, studio_overview: @studio_overview.attributes
    assert_redirected_to studio_overview_path(assigns(:studio_overview))
  end

  test "should destroy studio_overview" do
    assert_difference('Studio::Overview.count', -1) do
      delete :destroy, id: @studio_overview.to_param
    end

    assert_redirected_to studio_overviews_path
  end
end
