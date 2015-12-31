require 'test_helper'

class SessionTest < ActionDispatch::IntegrationTest
  def setup
    @current_user = users(:current_user)
  end

  test 'should log the user out when they delete their session' do
    get '/api/session', nil, authorization: auth_header(@current_user)
    assert_response :success

    delete '/api/session', nil, authorization: auth_header(@current_user)
    assert_response :success

    get '/api/session', nil, authorization: auth_header(@current_user)
    assert_response 401
  end
end
