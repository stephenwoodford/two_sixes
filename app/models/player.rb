class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :roll
  belongs_to :user

  has_many :rolls

  delegate :dice, to: :roll

  scope :with_dice, -> { where("dice_count > 0") }

  def lose_die
    raise UsageError.new("Player #{handle} has no dice remaining.") if dice_count == 0
    update_attributes(dice_count: dice_count - 1)
  end
end
