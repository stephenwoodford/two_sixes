class GamesController < ApplicationController
  before_action :authenticate_user!, except: :log

  def create
    @game = current_user.games.create
  end

  def start
    @game = current_user.games.find(params[:id])
    @game.start
  end

  def log
    game = current_user.games.find(params[:id])

    if params[:last_seen]
      since_round, since_call = params[:since].split("-").map(&:to_i)
      since_call += 1
    else
      since_round = 0
      since_call = 0
    end

    game.log_since(since_round, since_call)
  end
end
