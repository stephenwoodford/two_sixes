class Game < ActiveRecord::Base
  has_many :game_events

  def start
    if started?
      raise ArgumentError.new "Unable to start an already started game."
    else
      update_attributes(started_at: Time.now)
    end
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
end
