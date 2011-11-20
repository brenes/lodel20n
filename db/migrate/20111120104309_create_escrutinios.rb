class CreateEscrutinios < ActiveRecord::Migration
  def change
    create_table :escrutinios do |t|
      t.datetime :hora
      t.integer :territorio_id

      t.timestamps
    end
  end
end
