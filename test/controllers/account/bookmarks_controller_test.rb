require 'test_helper'

class Account::BookmarksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get account_bookmarks_index_url
    assert_response :success
  end

end
