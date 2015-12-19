require 'test_helper'

class ListTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User', email: 'user@example.com',
                     password: 'foobar', password_confirmation: 'foobar')
    @list = List.new(title: 'My New List', owner: @user)
  end

  test 'should be valid' do
    assert @list.valid?
  end

  test 'title should be present' do
    @list.title = ' '
    assert_not @list.valid?
  end

  test 'user should be present' do
    @list.owner = nil
    assert_not @list.valid?
  end
end
