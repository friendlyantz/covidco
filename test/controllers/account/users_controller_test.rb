require 'test_helper'

class Account::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get account_users_index_url
    assert_response :success
  end

end
