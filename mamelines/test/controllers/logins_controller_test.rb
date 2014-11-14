require 'test_helper'

class LoginsControllerTest < ActionController::TestCase
  test "should get intento_login" do
    get :intento_login
    assert_response :success
  end

end
