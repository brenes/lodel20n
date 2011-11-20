class CreateResultados < ActiveRecord::Migration
  def change
    create_table :resultados do |t|
      t.integer :escrutinio_id
      t.integer :partido_id

      t.timestamps
    end
  end
end
