class CreateTerritorios < ActiveRecord::Migration
  def change
    create_table :territorios do |t|
      t.string :nombre
      t.string :tipo
      t.integer :territorio_padre_id

      t.timestamps
    end
  end
end
