class CreateGameInvites < ActiveRecord::Migration
  def change
    create_table :game_invites do |t|
      t.string :email
      t.integer :user_id
      t.integer :game_id
      t.datetime :declined_at
      t.datetime :revoked_at
      t.datetime :accepted_at
      t.timestamps
    end
  end
end
