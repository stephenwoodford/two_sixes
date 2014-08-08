class AddRollToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :roll_id, :integer
  end
end
