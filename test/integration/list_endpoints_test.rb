require 'test_helper'

class ListEndpointsTest < ActionDispatch::IntegrationTest
  def setup
    @current_user = users(:current_user)
  end

  test 'should be able to get the owner of a list' do
    list = lists(:subscribed_list)
    get "/api/lists/#{list.id}/relationships/owner", nil,
        authorization: auth_header(@current_user)
    assert_response :success
    assert_no_errors
  end

  test 'should not be able to delete the owner of a list' do
    list = lists(:owned_list)
    delete "/api/lists/#{list.id}/relationships/owner", nil,
        authorization: auth_header(@current_user)
    assert_response 404
  end

  test 'should not be able to update the owner of a list' do
    list = lists(:owned_list)
    put "/api/lists/#{list.id}/relationships/owner", nil,
        authorization: auth_header(@current_user)
    assert_response 404
  end
end
