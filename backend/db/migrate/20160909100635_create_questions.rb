class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.references :game, foreign_key: true
      t.string :type
      t.string :title
      t.json :body
      t.integer :correct_count
      t.integer :wrong_count

      t.timestamps
    end
  end
end
