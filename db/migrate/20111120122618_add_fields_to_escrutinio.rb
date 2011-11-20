class AddFieldsToEscrutinio < ActiveRecord::Migration
  def change
    add_column :escrutinios, :total_contabilizados, :integer
    add_column :escrutinios, :total_abstenciones, :integer
    add_column :escrutinios, :total_nulos, :integer
    add_column :escrutinios, :total_blanco, :integer
    add_column :escrutinios, :pct_contabilizados, :double
    add_column :escrutinios, :pct_abstenciones, :double
    add_column :escrutinios, :pct_nulos, :double
    add_column :escrutinios, :pct_blanco, :double
  end
end
