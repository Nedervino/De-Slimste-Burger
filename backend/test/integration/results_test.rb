require 'test_helper'

class ResultsControllerTest < ActionDispatch::IntegrationTest
  test 'should index results per game' do
    get game_results_path(4)
    
    assert_response 200
    assert_equal 1, json_response.count
  end
  
  test 'should store results' do
    assert_difference('Result.count', 1) do
      post results_path,
           params: {
             result: {
               game_id: 4,
               name: 'Jaapie Krekel',
               answers: [
                 {
                   question_id: 1,
                   answer: '1%'
                 },
                 {
                   question_id: 2,
                   answer: '400 miljoen'
                 }
               ]
             }
           }

      assert_response 201
    end

    get game_results_path(4)

    assert_response 200
    assert_equal 1, json_response.count
  end
end
