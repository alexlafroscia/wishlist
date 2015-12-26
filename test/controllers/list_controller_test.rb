require 'test_helper'

class ListControllerTest < ActionController::TestCase
  def setup
    setup_json_api_headers
    @current_user = users(:current_user)
    authenticate @current_user

    # Set up the lists
    @owned_list = lists(:owned_list)
    @subscribed_list = lists(:subscribed_list)
    @inaccessible_list = lists(:inaccessible_list)
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
    get :show, 'id' => @subscribed_list.id
    assert_response :success, 'Found an accessible list'

    get :show, 'id' => @inaccessible_list.id
    assert_response 404, 'Did not find an inaccessible list'
  end

  test 'can update owned lists' do
    body = {
      type: 'lists',
      id: @owned_list.id,
      attributes: {
        title: 'This is the updated title'
      }
    }
    put :update, 'id' => @owned_list.id, 'data' => body
    assert_response :success
  end

  test 'cannot update an unowned lists' do
    id = @subscribed_list.id
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
    id = @inaccessible_list.id
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
    id = @owned_list.id
    delete :destroy, 'id' => id
    assert_response :success
  end

  test 'cannot delete an unowned list' do
    id = @subscribed_list.id
    delete :destroy, 'id' => id
    assert_response 403
  end

  test 'cannot delete an inaccessible list' do
    id = @inaccessible_list.id
    delete :destroy, 'id' => id
    assert_response 404
  end
end
