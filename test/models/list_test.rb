require 'test_helper'

class ListTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User', email: 'user@example.com',
                     password: 'foobar')
    @list = List.new(title: 'My New List', owner: @user)
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
    other = User.new(name: 'Other User', email: 'other@example.com',
                     password: 'foobar')
    sub = Subscription.new(user: other, list: @list)
    sub.save
    @list.destroy
    assert_not Subscription.exists?(sub.id), 'Subscription was destroyed'
  end

  test 'when a user is removed, all related subscriptions are deleted' do
    other = User.new(name: 'Other User', email: 'other@example.com',
                     password: 'foobar')
    other.save
    sub = Subscription.new(user: other, list: @list)
    sub.save
    other.destroy
    assert_not Subscription.exists?(sub.id), 'Subscription was destroyed'
  end
end
