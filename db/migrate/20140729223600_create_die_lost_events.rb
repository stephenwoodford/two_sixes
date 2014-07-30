class CreateDieLostEvents < ActiveRecord::Migration
  def change
    create_table :die_lost_events do |t|
      t.integer :round_id
      t.integer :player_id
      t.integer :final_number
      t.timestamps
    end
  end
end
