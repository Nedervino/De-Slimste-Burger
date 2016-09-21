require 'test_helper'

class GameControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get game_create_url
    assert_response :success
  end

end
