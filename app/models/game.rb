class Game < ActiveRecord::Base
  include Startable

  belongs_to :owner, class_name: "User"
  has_many :game_events
  has_many :players
  has_many :rounds
  has_many :invites

  def before_start
    seat_players
    assign_dice
  end

  def after_start
    start_round
  end

  def start_round
    raise UsageError.new "Unable to start round when game is not in progress." unless in_progress?

    number = round.number + 1 if round
    number ||= 0
    @round = rounds.create(number: number)
    add_event(@round)

    @round.start
  end

  def finish_round
    raise UsageError.new "Unable to end round when game is not in progress." unless in_progress?
    raise UsageError.new "Unable to end round before starting a round." unless round

    round.finish
    if players.with_dice.any?
      start_round
    else
      finish
    end
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
    elsif action.is_a? DieLostEvent
      name = "Die Lost"
    end

    game_events.create(number: number, action: action, name: name)
  end

  def round
    @round ||= rounds.order(:number).last
  end

  def last_event
    game_events.order(:number).last
  end

  def add_player(user, handle)
    raise UsageError.new "Unable to join once game has started." if started?

    player = players.create(user: user, handle: handle)
  end

  def seat_players
    raise UsageError.new "Unable to seat players once game has started." if started?

    players.shuffle.each_with_index { |player, seat| player.update_attributes(seat: seat) }
  end

  def assign_dice
    raise UsageError.new "Unable to assign dice once game has started." if started?

    players.each_with_index { |player, seat| player.update_attributes(dice_count: 5, starting_dice_count: 5) }
  end

  def player_for(user)
    players.where(user_id: user.id)
  end

  def bid(user, bid)
    raise UsageError.new "Unable to bid when game is not in progress." unless in_progress?

    player = player_for(user)
    legal_bid = round.bid(player, bid)

    unless legal_bid
      finish_round
    end
  end

  def bs(user)
    raise UsageError.new "Unable to call bs when game is not in progress." unless in_progress?

    player = player_for(user)
    round.bs(player)

    finish_round
  end
end
