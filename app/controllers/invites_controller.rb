class InvitesController < ApplicationController
  before_action :authenticate_user!

  def accept
    invite = current_user.invites.open_or_declined.find(params[:id])
    handle = params[:handle]
    handle = current_user.name if handle.blank?
    invite.accept(handle)

    redirect_to invite.game
  end

  def decline
    invite = current_user.invites.open.find(params[:id])
    invite.decline

    redirect_to games_path
  end

  def revoke
    invite = Invite.find(params[:id])
    raise ActiveRecord::RecordNotFound.new if invite.game_owner != current_user

    begin
      invite.revoke
    rescue UsageError => ex
      flash[:alert] = ex.to_s
    end
    redirect_to invite.game
  end
end
