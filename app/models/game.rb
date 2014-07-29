class Game < ActiveRecord::Base
  include Startable

  has_many :game_events
  has_many :players
  has_many :rounds

  def before_start
    seat_players
  end

  def after_start
    start_round
  end

  def start_round
    raise ArgumentError.new "Unable to start round when game is not in progress." unless in_progress?

    number = round.number + 1 if round
    number ||= 0
    @round = rounds.create(number: number)
    add_event(@round)

    @round.start
  end

  def events(last_seen=nil)
    if last_seen
      game_events.where("number > ?", last_seen)
    else
      game_events
    end
  end

  def add_event(action)
    number = last_event.number + 1 if last_event
    number ||= 0

    if action.is_a? Call
      if action.bs?
        name = "BS"
      else
        if action.legal?
          name = "Bid"
        else
          name = "IllegalBid"
        end
      end
    elsif action.is_a? Round
      name = "New Round"
    elsif action.is_a? Roll
      name = "Dice Roll"
    end

    game_events.create(number: number, action: action, name: name)
  end

  def round
    @round ||= rounds.order(:number).last
  end

  def last_event
    game_events.order(:number).last
  end

  def add_player(user, name)
    raise ArgumentError.new "Unable to join once game has started." if started?

    player = players.create(user: user, dice_count: 5, starting_dice_count: 5, name: name)
  end

  def seat_players
    raise ArgumentError.new "Unable to join once game has started." if started?

    players.shuffle.each_with_index { |player, seat| player.update_attributes(seat: seat) }
  end

  def player_for(user)
    players.where(user_id: user.id)
  end

  def bid(user, bid)
    player = player_for(user)
    round.bid(player, bid)
  end

  def bs(user)
    player = player_for(user)
    round.bs(player)
  end
end
