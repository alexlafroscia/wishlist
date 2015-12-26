require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  def setup
    @user = users(:current_user)
    @subscribed_list = lists(:subscribed_list)
    @subscription = subscriptions(:current_user_subscription)
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
    @subscribed_list.owner = @user
    @subscribed_list.save
    assert @subscription.invalid?, 'Subscription should be invalid'
  end

  test 'with a subscription, the user and list relationships exist' do
    assert_equal @user.subscribed_lists.length, 1, 'User has a subscribed list'
    assert_equal @subscribed_list.subscribers.length, 1, 'List has a subscriber'
  end
end
