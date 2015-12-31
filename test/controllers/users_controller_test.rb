require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    setup_json_api_headers
  end

  test 'can create a new user' do
    body = configure_json('users',
                          email: 'test@example.com',
                          password: 'foobar',
                          name: 'Test User'
                         )
    post :create, body
    assert_response :success
    assert_no_errors
    assert_attribute_not_included 'password'
  end
end
