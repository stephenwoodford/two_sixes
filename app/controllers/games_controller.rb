class GamesController < ApplicationController
  before_action :authenticate_user!, except: [:events, :show, :stats]

  ##############################
  ##  Controller Methods      ##
  ##  (Sorted alphabetically) ##
  ##############################

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

  def create
    @game = current_user.owned_games.create
    handle = params[:handle]
    handle = current_user.name if handle.blank?
    @game.add_player(current_user, handle)

    redirect_to @game
  end

  def events
    game = Game.find(params[:id])

    render json: game.events(params[:prev_event])
  end

  def invite
    game = current_user.owned_games.find(params[:id])

    email = params[:invite][:email].downcase
    user = User.find_by_email(email)
    invite = game.invites.create(user: user, email: email)
    if invite.valid?
      UserMailer.invite(invite).deliver
    else
      messages = invite.errors.messages
      if messages[:email] == ["is not an email"]
        error_message = ", email address is invalid"
      elsif messages[:email] == ["has already been taken"]
        error_message = ", has already been invited"
      end
      flash[:alert] = "Unable to invite #{invite.email}#{error_message}."
    end
    redirect_to game
  end

  def show
    @game = Game.find(params[:id])
    @player = @game.player_for(current_user) if current_user
    @is_owner = current_user && current_user.owns?(@game)
    @can_revoke = @is_owner
    @can_invite = @is_owner

    if @game.finished?
      redirect_to stats_games_path(@game)
    elsif !@game.started?
      render "waiting" and return
    end
  end

  def start
    game = current_user.owned_games.find(params[:id])
    game.start

    redirect_to game
  end

  def stats
    @game = Game.find(params[:id])
  end
end
