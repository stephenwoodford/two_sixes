class Game < ActiveRecord::Base
  include Startable

  has_many :game_events
  has_many :players
  has_many :rounds

  def after_start
    start_round
  end

  def start_round
    raise ArgumentError.new "Unable to start round when game is not in progress." unless in_progress?

    number = round.number + 1 if round
    number ||= 0
    @round = rounds.create(number: number)

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

    game_events.create(number: number, action: action)
  end

  def round
    @round ||= rounds.order(:number).last
  end

  def last_event
    game_events.order(:number).last
  end
end
