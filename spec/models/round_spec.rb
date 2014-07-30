require 'rails_helper'

require_relative '../lib/startable_spec'

describe Round do
  let (:game) { Game.new }
  let (:obj) { Round.new(game: game) }

  it_behaves_like "a Startable"

  describe "#before_start" do
    it "rolls each player's dice" do
      allow(obj).to receive_message_chain(:players, :order) { [ Player.new, Player.new ] }
      allow(game).to receive(:add_event)
      expect(obj).to receive(:roll_dice).twice
      obj.before_start
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

    context "when the round has started" do
      it "raises an error" do
        allow(obj).to receive(:started?) { true }
        p = Player.new(dice_count: 5)
        expect { obj.roll_dice(p) }.to raise_error(UsageError)
      end
    end
  end

  describe "#total" do
    it "raises an error if given an invalid face_value" do
      expect { obj.total(0) }.to raise_error(ArgumentError)
      expect { obj.total(7) }.to raise_error(ArgumentError)
    end

    it "returns the sum across all rolls" do
      roll1 = Roll.new
      allow(roll1).to receive(:count).with(5, true) { 5 }
      roll2 = Roll.new
      allow(roll2).to receive(:count).with(5, true) { 0 }
      roll3 = Roll.new
      allow(roll3).to receive(:count).with(5, true) { 2 }
      allow(obj).to receive(:rolls) { [roll1, roll2, roll3] }
      expect(obj.total(5)).to eq(7)
    end

    it "doesn't count ones if they're not wild" do
      roll1 = Roll.new
      expect(roll1).to receive(:count).with(5, false) { 5 }
      allow(obj).to receive(:rolls) { [roll1] }
      allow(obj).to receive(:ones_wild?) { false }
      obj.total(5)
    end
  end

  describe "#prev_bid_correct?" do
    before do
      allow(obj).to receive(:prev_bid) { Bid.new(5, 4) }
    end

    context "when the previous bid is less than the total" do
      it "returns true" do
        allow(obj).to receive(:total) { 10 }
        expect(obj.prev_bid_correct?).to be true
      end
    end

    context "when the previous bid is equal to the total" do
      it "returns true" do
        allow(obj).to receive(:total) { 5 }
        expect(obj.prev_bid_correct?).to be true
      end
    end

    context "when the previous bid is greater than the total" do
      it "returns false" do
        allow(obj).to receive(:total) { 1 }
        expect(obj.prev_bid_correct?).to be false
      end
    end
  end
end
