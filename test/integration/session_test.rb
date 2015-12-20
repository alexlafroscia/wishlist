require 'test_helper'

class SessionTest < ActionDispatch::IntegrationTest
  def setup
    @current_user = User.new(name: 'Example User',
                             email: 'user@example.com',
                             password: 'foobar')
    @current_user.save
  end

  test 'should log the user out when they delete their session' do
    get '/api/session', nil, authorization: auth_header(@current_user)
    assert_response :success

    delete '/api/session', nil, authorization: auth_header(@current_user)
    assert_response :success

    get '/api/session', nil, authorization: auth_header(@current_user)
    assert_response 401
  end

  private

    def auth_header(user)
      token = user.auth_token
      ActionController::HttpAuthentication::Token.encode_credentials(token)
    end
end
