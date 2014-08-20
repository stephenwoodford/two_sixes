class AddDescriptionToDieLostEvent < ActiveRecord::Migration
  def change
    add_column :die_lost_events, :description, :string
  end
end
