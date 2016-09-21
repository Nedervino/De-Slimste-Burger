class DefaultValues < ActiveRecord::Migration[5.0]
  def change
    change_column_default :games, :results_count, from: nil, to: 0
    change_column_default :games, :questions_count, from: nil, to: 0
    

    change_column_default :questions, :correct_count, from: nil, to: 0
    change_column_default :questions, :wrong_count, from: nil, to: 0
  end
end
