class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :seat
      t.integer :user_id
      t.integer :dice_count
      t.integer :starting_dice_count
      t.integer :finish
      t.integer :game_id
      t.string :name
      t.timestamps
    end
  end
end
