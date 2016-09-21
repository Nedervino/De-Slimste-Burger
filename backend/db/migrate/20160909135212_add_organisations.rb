class AddOrganisations < ActiveRecord::Migration[5.0]
  def change
    add_column :results, :organisation, :string
  end
end
