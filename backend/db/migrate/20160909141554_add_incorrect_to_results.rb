class AddIncorrectToResults < ActiveRecord::Migration[5.0]
  def change
    add_column :results, :incorrect_count, :integer, default: 0
  end
end
