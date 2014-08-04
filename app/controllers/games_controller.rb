class GamesController < ApplicationController
  before_action :authenticate_user!, except: :events

  def index
  end

  def create
    @game = current_user.owned_games.create
    handle = params[:handle]
    handle = current_user.name if handle.blank?
    @game.add_player(current_user, handle)
  end

  def start
    @game = current_user.owned_games.find(params[:id])
    player = @game.player_for(current_user)
    handle = params[:handle]
    handle = current_user.name if handle.blank?
    player.update_attributes(handle: handle)
    @game.start
  end

  def events
    game = Game.find(params[:id])

    render json: game.events(params[:prev_event])
  end

  def invite
    game = current_user.owned_games.find(params[:id])

    params[:emails].each do |email|
      email = email.downcase
      user = User.find_by_email(email)
      invite = game.invites.create(user: user, email: email)
      UserMailer.invite(invite).deliver
    end
  end

  def join
    game = current_user.invites.find_by(game_id: params[:id])
    handle = params[:handle]
    handle = current_user.name if handle.blank?
    game.add_player(current_user, handle)
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
