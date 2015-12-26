require 'test_helper'

class Api::SessionControllerTest < ActionController::TestCase
  def setup
    @current_user = users(:current_user)
    @current_user.save!
  end

  def teardown
    @current_user = nil
  end

  test 'should be able to get the current user when logged in' do
    authenticate @current_user
    get :get
    assert_equal @current_user, assigns[:current_user], 'Verified the user'
    assert_response :success
    assert_attribute_value 'email', 'user@example.com'
    assert_attribute_value 'name', 'Example User'
    assert_attribute_not_included 'password'
  end

  test 'should error when getting the current user when not logged on' do
    get :get
    assert_response 401
  end

  test 'should log a user in with email and password' do
    post :create, email: 'user@example.com', password: default_password
    assert_response :success
    body = JSON.parse(@response.body)
    assert_equal body['auth_token'], @current_user.auth_token
  end

  test 'should fail to log in with incorrect email and password' do
    post :create, email: 'user@example.com', password: ''
    assert_response 401
  end
end
