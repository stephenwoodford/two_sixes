class CreateGameEvents < ActiveRecord::Migration
  def change
    create_table :game_events do |t|
      t.string :action_type
      t.integer :action_id
      t.integer :number, null: false
      t.integer :game_id
      t.timestamps
    end
  end
end
