class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  scope :with_dice, -> { where("dice_count > 0") }

  def lose_die
    raise UsageError.new("Player #{name} has no dice remaining.") if dice_count == 0
    update_attributes(dice_count: dice_count - 1)
  end
end
