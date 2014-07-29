class AddLegalToCall < ActiveRecord::Migration
  def change
    add_column :calls, :legal, :boolean, default: true
  end
end
