require 'test_helper'

class ListTest < ActiveSupport::TestCase
  def setup
    @user = users(:current_user)
    @list = lists(:subscribed_list)
  end

  test 'should be valid' do
    assert @list.valid?
  end

  test 'title should be present' do
    @list.title = ' '
    assert_not @list.valid?
  end

  test 'owner must be present' do
    @list.owner = nil
    assert_not @list.valid?
  end

  test 'when a list is removed, all related subscriptions are deleted' do
    sub = subscriptions(:current_user_subscription)
    @list.destroy
    assert_not Subscription.exists?(sub.id), 'Subscription was destroyed'
  end

  test 'when a user is removed, all related subscriptions are deleted' do
    sub = subscriptions(:current_user_subscription)
    @user.destroy
    assert_not Subscription.exists?(sub.id), 'Subscription was destroyed'
  end
end
