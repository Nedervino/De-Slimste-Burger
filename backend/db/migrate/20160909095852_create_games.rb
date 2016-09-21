class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :results_count
      t.integer :questions_count

      t.timestamps
    end
  end
end
