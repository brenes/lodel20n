class AddFieldsToPartido < ActiveRecord::Migration
  def change
    add_column :partidos, :id_api, :integer
  end
end
