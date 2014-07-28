class GamesController < ApplicationController
  before_action :authenticate_user!, except: :log

  def create
    @game = current_user.games.create
  end

  def start
    @game = current_user.games.find(params[:id])
    @game.start
  end

  def events
    game = current_user.games.find(params[:id])

    game.events(params[:prev_event])
  end
end
