require 'test_helper'

class AuthTokenTest < ActiveSupport::TestCase
  def setup
    @user = users(:current_user)
    @token = auth_tokens(:current_user_token)
  end

  test 'should be invalid if it has no user' do
    @token.user = nil
    assert @token.invalid?
  end

  test 'should be valid with user and value' do
    assert @token.valid?
  end

  test 'should generate a value on save, if it does not have one' do
    @token.value = nil
    @token.valid? # Check validation to trigger hook
    assert @token.value.present?
  end

  test 'can regenerate the value for a token' do
    previous_value = @token.value
    @token.regenerate_token
    assert_not_equal @token.value, previous_value
  end

  test 'it maintains the original auth token if it is present' do
    previous_value = @token.value
    @token.valid? # Check validation to trigger hook
    assert_equal @token.value, previous_value
  end
end
