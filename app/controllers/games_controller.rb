class GamesController < ApplicationController
  before_action :authenticate_user!, except: :events

  def index
  end

  def create
    @game = current_user.games.create
  end

  def start
    @game = current_user.games.find(params[:id])
    @game.start
  end

  def events
    game = Game.find(params[:id])

    render json: game.events(params[:prev_event])
  end

  def join
    game = current_user.game_invites.find_by(game_id: params[:id])
    game.add_player(current_user, current_user.name)
  end

  def bid
    game = current_user.games.find(params[:id])
    number = params[:number]
    face_value = params[:face_value]
    errors = []
    errors << "The bid must include a total number." unless number
    errors << "The bid must include a valid total number." unless number =~ /\A\d+\z/
    errors << "The bid must include a face value." unless face_value =~ /\A\d+\z/
    errors << "The bid must include a valid face value." unless face_value =~ /\A\d+\z/

    render status: 400, json: {errors: errors} and return if errors.any?

    bid = Bid.new(number.to_i, face_value.to_i)
    game.bid(current_user, bid)
  end

  def bs
    game = current_user.games.find(params[:id])
    game.bs(current_user)
  end
end
