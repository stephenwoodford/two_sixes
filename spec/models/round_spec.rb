require 'rails_helper'

require_relative '../lib/startable_spec'

describe Round do
  let (:obj) { Round.new }

  it_behaves_like "a Startable"

  describe "#start" do
    it "rolls each player's dice" do
      allow(obj).to receive(:players) { [ Player.new, Player.new ] }
      expect(obj).to receive(:roll_dice).twice
      obj.start
    end
  end

  describe "#roll_dice" do
    it "rolls the correct number of dice" do
      p = Player.new(dice_count: 5)
      roll = obj.roll_dice(p)
      expect(roll.dice_count).to eq(5)
      p = Player.new(dice_count: 2)
      roll = obj.roll_dice(p)
      expect(roll.dice_count).to eq(2)
    end
  end
end
