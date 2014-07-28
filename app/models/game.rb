class Game < ActiveRecord::Base
  has_many :game_events
  has_many :players
  has_many :rounds

  def start
    raise ArgumentError.new "Unable to start an already started game." if started?

    update_attributes(started_at: Time.now)
    players.each {|p| roll_dice(p) }
  end

  def started?
    !!started_at
  end

  def finish
    if finished?
      raise ArgumentError.new "Unable to finish an already finished game."
    elsif !started?
      raise ArgumentError.new "Unable to finish a game before is starts."
    else
      update_attributes(finished_at: Time.now)
    end
  end

  def finished?
    !!finished_at
  end

  def in_progress?
    started? && !finished?
  end

  def events(last_seen=nil)
    if last_seen
      game_events.where("number > ?", last_seen)
    else
      game_events
    end
  end

  def roll_dice(player)
    roll = Roll.new(round: round, player: player)
    roll.dice = (0...player.dice_count).map{ Random.rand(6) + 1 }
    roll.save!

    roll
  end

  def round
    @round ||= rounds.order(:number).last
  end
end
