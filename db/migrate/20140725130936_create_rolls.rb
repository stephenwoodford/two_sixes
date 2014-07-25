class CreateRolls < ActiveRecord::Migration
  def change
    create_table :rolls do |t|
      t.integer :round_id
      t.integer :player_id
      t.string :dice_string
      t.timestamps
    end
  end
end
