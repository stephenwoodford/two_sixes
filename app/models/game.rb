class Game < ActiveRecord::Base
  def start
  end

  def log_since(round, call)
    log = GameLog.new
    game.rounds.where("number >= ?", since_round).each do |round|
      first_call = round.number == since_round ? since_call : 0
      round.calls.where("sequence_number >= ?", first_call).each do |call|
        log.entries << LogEntry.new(call)
        if call.bs?
          showdown = Showdown.new
          showdown.bid = call.prev_call
          round.rolls.each do |roll|
            showdown.add_roll(roll.player, roll.count(call.prev_call, round.wild?))
          end
          log.entries << LogEntry.new(showdown)
        end
      end
    end
  end
end
