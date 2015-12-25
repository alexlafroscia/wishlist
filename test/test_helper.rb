# Start Test Coverage
if ENV['CI']
  require 'coveralls'
  Coveralls.wear!('rails')
else
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_group 'Resources', 'app/resources'
  end
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in
  # alphabetical order.
  fixtures :all

  # Authenticate a user in a Functional test
  def authenticate(user)
    token = user.auth_token
    @request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Token.encode_credentials(token)
  end

  # Generate the authentication header for an Integration test
  def auth_header(user)
    token = user.auth_token
    ActionController::HttpAuthentication::Token.encode_credentials(token)
  end

  def assert_no_errors
    body = ActiveSupport::JSON.decode(@response.body)
    if body.key?('errors')
      body['errors'].each { |error| puts error }
    end
    assert_not body.key?('errors'), 'Expected response to have no errors'
  end

  # Set up request headers for JSON:API requests
  def setup_json_api_headers
    @request.headers['Content-Type'] = JSONAPI::MEDIA_TYPE
  end

  def configure_json(type, data = {})
    {
      data: {
        type: type,
        attributes: data
      }
    }
  end

  def raw_put(action, params, body)
    @request.env['RAW_PUT_DATA'] = body
    response = put(action, params)
    @request.env.delete('RAW_PUT_DATA')
    response
  end

  def assert_attribute_included(attr)
    body = JSON.parse(@response.body)
    assert body['data']['attributes'][attr],
           "Attribute '#{attr}' should be included"
  end

  def assert_attribute_value(attr, value)
    body = JSON.parse(@response.body)
    v = body['data']['attributes'][attr]
    assert_equal value, v,
                 "Attribute value should have been #{value}, was #{v}"
  end

  def assert_attribute_not_included(attr)
    body = JSON.parse(@response.body)
    assert_not body['data']['attributes'][attr],
               "Attribute '#{attr}' should not be included"
  end
end
