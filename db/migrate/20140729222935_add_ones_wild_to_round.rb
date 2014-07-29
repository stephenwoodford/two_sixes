class AddOnesWildToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :ones_wild, :boolean, default: true
  end
end
