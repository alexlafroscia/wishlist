require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User', email: 'user@example.com',
                     password: 'foobar')
    other = User.new(name: 'Other User', email: 'other@example.com',
                     password: 'foobar')
    @list = List.new(title: 'My List', owner: other)
    @subscription = Subscription.new(user: @user, list: @list)
  end

  def teardown
    @user = nil
    @list = nil
    @subscription = nil
  end

  test 'list must be present' do
    @subscription.list = nil
    assert @subscription.invalid?, 'Subscription should be invalid'
  end

  test 'user must be present' do
    @subscription.user = nil
    assert @subscription.invalid?, 'Subscription should be invalid'
  end

  test "can't subscribe user to their own list" do
    @list.owner = @user
    assert @subscription.invalid?, 'Subscription should be invalid'
  end

  test 'with a subscription, the user and list relationships exist' do
    @subscription.save
    assert_equal @user.subscribed_lists.length, 1, 'User has a subscribed list'
    assert_equal @list.subscribers.length, 1, 'List has a subscriber'
  end
end
