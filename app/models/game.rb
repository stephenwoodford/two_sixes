class Game < ActiveRecord::Base
  has_many :game_events, order: :number

  def start
  end

  def events(last_seen=nil)
    if last_seen
      game_events.where("number > ?", last_seen)
    else
      game_events
    end
  end
end
