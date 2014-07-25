class GamesController < ApplicationController
  before_action :authenticate_user!

  def create
    @game = current_user.games.create
  end

  def start
    @game = current_user.games.find(params[:id])
    @game.start
  end
end
