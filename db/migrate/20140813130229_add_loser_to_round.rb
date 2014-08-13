class AddLoserToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :loser_id, :integer
  end
end
