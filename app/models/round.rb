class Round < ActiveRecord::Base
  include Startable

  belongs_to :game

  has_many :players, through: :game
  has_many :rolls

  def after_start
    players.order(:seat_number).each do |p|
      roll = roll_dice(p)
      game.add_event(roll)
    end
  end

  def roll_dice(player)
    roll = self.rolls.build(player: player)
    roll.dice = (0...player.dice_count).map{ Random.rand(6) + 1 }
    roll.save!

    roll
  end
end
