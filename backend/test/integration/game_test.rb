require 'test_helper'

class GameControllerTest < ActionDispatch::IntegrationTest
  test 'should index results per game' do
    get game_results_path(4)
    
    assert_response 200
  end
  
  test 'should store results' do
    assert_difference('Game.count', 1) do
      post games_path
  
      assert_response 201
      # assert_equal 1, Question.find(1).correct_count
      # assert_equal 1, Question.find(2).wrong_count
    end
  end
end
