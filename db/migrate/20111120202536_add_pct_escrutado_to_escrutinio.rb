class AddPctEscrutadoToEscrutinio < ActiveRecord::Migration
  def change
    add_column :escrutinios, :pct_escrutado, :float
  end
end
