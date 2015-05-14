class GamesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :stats]

  ##############################
  ##  Controller Methods      ##
  ##  (Sorted alphabetically) ##
  ##############################

  def create
    @game = current_user.owned_games.create
    handle = params[:handle]
    handle = current_user.name if handle.blank?
    @game.add_player(current_user, handle)

    redirect_to @game
  end

  def index
    @games = current_user.games.in_progress
    @games += current_user.games.waiting
  end

  def invite
    game = current_user.owned_games.find(params[:id])

    email = params[:invite][:email].downcase
    user = User.find_by_email(email)
    invite = game.invites.create(user: user, email: email)
    if invite.valid?
      game.add_event(invite)
      #UserMailer.invite(invite).deliver # TODO: Fix email on production
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
    @is_owner = !!(current_user && current_user.owns?(@game))
    @can_revoke = @is_owner
    @can_invite = @is_owner
    @urls = {}
    @urls[:bid] = bid_api_v1_game_url(@game)
    @urls[:bs] = bs_api_v1_game_url(@game)
    @urls[:events] = events_api_v1_game_url(@game)
    @urls[:comments] = comments_api_v1_game_url(@game)

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
