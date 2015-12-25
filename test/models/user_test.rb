require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User', email: 'user@example.com',
                     password: 'foobar')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = ' '
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = ' '
    assert_not @user.valid?
  end

  test 'email must be unique' do
    @user.save
    user2 = User.new(name: 'Other User', email: 'user@example.com',
                     password: 'foobar')
    assert_not user2.valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w(user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn)
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w(user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com)
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'email address should be lower case' do
    @user.email = 'USER@EXAMPLE.COM'
    @user.save
    assert_equal @user.email, 'user@example.com'
  end

  test 'auth token will be set on create' do
    assert_not @user.auth_token?
    @user.save
    assert @user.auth_token?
  end

  test 'auth token can be regenerated' do
    @user.save # Generate initial token
    initial_token = @user.auth_token
    new_token = @user.regenerate_auth_token
    assert_not_equal initial_token, new_token
  end

  test 'it verifies a correct password' do
    assert @user.authenticate('foobar')
  end

  test 'it rejects an incorrect password' do
    assert_not @user.authenticate('foobaz')
  end

  test 'it successfully authenticates a correct email and password' do
    @user.save
    user = User.authenticate('user@example.com', 'foobar')
    assert_equal @user, user
  end

  test 'it rejects a correct email and incorrect password' do
    @user.save
    user = User.authenticate('user@example.com', 'foobaz')
    assert_equal user, nil
  end

  test 'it rejects an incorrect email' do
    @user.save
    user = User.authenticate('fake@example.com', 'foobar')
    assert_equal user, nil
  end

  test 'lists should be destroyed with their owner' do
    @user.save
    list = List.new(title: 'Test List', owner: @user)
    list.save
    @user.destroy
    assert_not List.exists?(list.id), 'List should be destroyed'
  end

  test 'it can get its accessible lists' do
    @user.save
    # Set up an owned list
    list = List.new(title: 'List 1', owner: @user)
    list.save

    # Set up a subscribed list
    other = User.new(name: 'Other', email: 'foo@bar.com', password: 'foobar')
    other.save
    list2 = List.new(title: 'List 2', owner: other)
    list2.save
    sub = Subscription.new(list: list2, user: @user)
    sub.save

    assert_equal 2, @user.accessible_lists.length
  end
end
