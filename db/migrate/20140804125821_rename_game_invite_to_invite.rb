class RenameGameInviteToInvite < ActiveRecord::Migration
  def change
    rename_table :game_invites, :invites
  end
end
