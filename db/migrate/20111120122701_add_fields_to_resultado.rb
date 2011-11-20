class AddFieldsToResultado < ActiveRecord::Migration
  def change
    add_column :resultados, :escanos, :integer
    add_column :resultados, :total_votos, :integer
    add_column :resultados, :pct_votos, :integer
  end
end
