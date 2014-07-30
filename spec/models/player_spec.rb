require 'rails_helper'

describe Player do
  describe "scopes" do
    describe "with_dice" do
      it "returns players with dice" do
        Player.create(name: "Player 1", dice_count: 5)
        Player.create(name: "Player 2", dice_count: 0)
        expect(Player.with_dice.count).to eq(1)
        expect(Player.with_dice.first.name).to eq("Player 1")
      end
    end
  end

  describe "#lose_die" do
    it "decrements the number of dice a player has" do
      p = Player.create(dice_count: 5)
      p.lose_die
      expect(p.dice_count).to eq(4)
    end

    it "raises an error if the player has no dice" do
      p = Player.create(dice_count: 0)
      expect { p.lose_die }.to raise_error(UsageError)
    end
  end
end
