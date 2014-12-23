require 'test_helper'

class CiudadeControllerTest < ActionController::TestCase
  test "should get photo" do
    get :photo
    assert_response :success
  end

end
