class GamesController < ApplicationController
  before_action :authenticate_user!, except: :events

  def create
    @game = current_user.games.create
  end

  def start
    @game = current_user.games.find(params[:id])
    @game.start
  end

  def events
    game = current_user.games.find(params[:id])

    render json: game.events(params[:prev_event])
  end

  def join
    game = current_user.game_invites.find_by(game_id: params[:id])
    game.add_player(current_user, current_user.name)
  end
end
