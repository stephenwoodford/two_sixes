class AddNameToGameEvent < ActiveRecord::Migration
  def change
    add_column :game_events, :name, :string
  end
end
