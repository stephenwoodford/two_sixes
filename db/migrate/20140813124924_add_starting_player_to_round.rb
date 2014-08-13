class AddStartingPlayerToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :starting_player_id, :integer
  end
end
