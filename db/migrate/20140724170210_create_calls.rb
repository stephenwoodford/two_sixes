class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.integer :number
      t.integer :face_value
      t.integer :sequence_number
      t.boolean :bs
      t.integer :player_id
      t.integer :round_id
      t.timestamps
    end
  end
end
