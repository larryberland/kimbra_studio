require 'test_helper'

class Admin::Customer::EmailsControllerTest < ActionController::TestCase
  setup do
    @admin_customer_email = admin_customer_emails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_customer_emails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_customer_email" do
    assert_difference('Admin::Customer::Email.count') do
      post :create, admin_customer_email: @admin_customer_email.attributes
    end

    assert_redirected_to admin_customer_email_path(assigns(:admin_customer_email))
  end

  test "should show admin_customer_email" do
    get :show, id: @admin_customer_email.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_customer_email.to_param
    assert_response :success
  end

  test "should update admin_customer_email" do
    put :update, id: @admin_customer_email.to_param, admin_customer_email: @admin_customer_email.attributes
    assert_redirected_to admin_customer_email_path(assigns(:admin_customer_email))
  end

  test "should destroy admin_customer_email" do
    assert_difference('Admin::Customer::Email.count', -1) do
      delete :destroy, id: @admin_customer_email.to_param
    end

    assert_redirected_to admin_customer_emails_path
  end
end
