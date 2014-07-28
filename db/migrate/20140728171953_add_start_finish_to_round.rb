class AddStartFinishToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :started_at, :datetime
    add_column :rounds, :finished_at, :datetime
  end
end
