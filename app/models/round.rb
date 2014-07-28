class Round < ActiveRecord::Base
  include Startable

  has_many :players, through: :game
  has_many :rolls

  def after_start
    players.each {|p| roll_dice(p) }
  end

  def roll_dice(player)
    roll = self.rolls.build(player: player)
    roll.dice = (0...player.dice_count).map{ Random.rand(6) + 1 }
    roll.save!

    roll
  end
end
