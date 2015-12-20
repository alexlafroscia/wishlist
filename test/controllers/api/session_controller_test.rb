require 'test_helper'

class Api::SessionControllerTest < ActionController::TestCase
  def setup
    @current_user = User.new(name: 'Example User',
                             email: 'user@example.com',
                             password: 'foobar')
    @current_user.save
  end

  def teardown
    @current_user = nil
  end

  test 'should be able to get the current user when logged in' do
    authenticate @current_user
    get :get
    assert_equal @current_user, assigns[:current_user], 'Verified the user'
    assert_response :success
  end

  test 'should error when getting the current user when not logged on' do
    get :get
    assert_response 401
  end

  test 'should log a user in with email and password' do
    post :create, email: 'user@example.com', password: 'foobar'
    assert_response :success
  end

  test 'should fail to log in with incorrect email and password' do
    post :create, email: 'user@example.com', password: ''
    assert_response 401
  end
end
