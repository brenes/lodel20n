class CreatePartidos < ActiveRecord::Migration
  def change
    create_table :partidos do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
