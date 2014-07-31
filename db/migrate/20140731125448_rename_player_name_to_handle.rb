class RenamePlayerNameToHandle < ActiveRecord::Migration
  def change
    rename_column :players, :name, :handle
  end
end
