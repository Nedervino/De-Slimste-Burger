class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.references :game, foreign_key: true
      t.string :name
      t.integer :correct_count
      t.integer :score
      t.json :answers

      t.timestamps
    end
  end
end
