class AddFieldsToTerritorio < ActiveRecord::Migration
  def change
    add_column :territorios, :tipo_api, :integer
    add_column :territorios, :id_api, :integer
    add_column :territorios, :escanos, :integer
  end
end
