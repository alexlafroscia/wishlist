require 'test_helper'

class ListControllerTest < ActionController::TestCase
  def setup
    setup_json_api_headers
    @current_user = User.new(name: 'Example User',
                             email: 'test@example.com',
                             password: 'foobar')
    @current_user.save
    authenticate @current_user

    # Set up the lists
    other = User.new(name: 'Other User',
                     email: 'other@example.com',
                     password: 'foobar')
    other.save!
    @list1 = List.new(title: 'List 1', owner: @current_user)
    @list1.save!
    @list2 = List.new(title: 'List 2', owner: other)
    @list2.save!
    @list3 = List.new(title: 'List 3', owner: other)
    @list3.save!
    subscription = Subscription.new(list: @list2, user: @current_user)
    subscription.save!
  end

  def teardown
    @current_user = nil
  end

  test 'only fetches lists the user owns or is is subscribed to' do
    get :index
    assert_no_errors
    body = JSON.parse(@response.body)
    assert_equal 2, body['data'].length, "Returned the user's lists"
  end

  test 'does not allow access to unsubscribed lists' do
    get :show, 'id' => @list2.id
    assert_response :success, 'Found an accessible list'

    get :show, 'id' => @list3.id
    assert_response 404, 'Did not find an inaccessible list'
  end

  test 'can update owned lists' do
    body = {
      type: 'lists',
      id: @list1.id,
      attributes: {
        title: 'This is the updated title'
      }
    }
    put :update, 'id' => @list1.id, 'data' => body
    assert_response :success
  end

  test 'cannot update an unowned lists' do
    id = @list2.id
    body = {
      type: 'lists',
      id: id,
      attributes: {
        title: 'This is the updated title'
      }
    }
    put :update, 'id' => id, 'data' => body
    assert_response 403
  end

  test 'cannot update an inaccessible list' do
    id = @list3.id
    body = {
      type: 'lists',
      id: id,
      attributes: {
        title: 'This is the updated title'
      }
    }
    put :update, 'id' => id, 'data' => body
    assert_response 404
  end

  test 'can delete owned lists' do
    id = @list1.id
    delete :destroy, 'id' => id
    assert_response :success
  end

  test 'cannot delete an unowned list' do
    id = @list2.id
    delete :destroy, 'id' => id
    assert_response 403
  end

  test 'cannot delete an inaccessible list' do
    id = @list3.id
    delete :destroy, 'id' => id
    assert_response 404
  end
end
