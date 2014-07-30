require 'rails_helper'

require_relative '../lib/startable_spec'

describe Round do
  let (:game) { Game.new }
  subject { Round.new(game: game) }

  it_behaves_like "a Startable"

  describe "#before_start" do
    it "rolls each player's dice" do
      allow(subject).to receive_message_chain(:players, :order) { [ Player.new, Player.new ] }
      allow(game).to receive(:add_event)
      is_expected.to receive(:roll_dice).twice
      subject.before_start
    end
  end

  describe "#roll_dice" do
    it "rolls the correct number of dice" do
      p = Player.new(dice_count: 5)
      roll = subject.roll_dice(p)
      expect(roll.dice_count).to eq(5)
      p = Player.new(dice_count: 2)
      roll = subject.roll_dice(p)
      expect(roll.dice_count).to eq(2)
    end

    context "when the round has started" do
      it "raises an error" do
        allow(subject).to receive(:started?) { true }
        p = Player.new(dice_count: 5)
        expect { subject.roll_dice(p) }.to raise_error(UsageError)
      end
    end
  end

  describe "#total" do
    it "raises an error if given an invalid face_value" do
      expect { subject.total(0) }.to raise_error(ArgumentError)
      expect { subject.total(7) }.to raise_error(ArgumentError)
    end

    it "returns the sum across all rolls" do
      roll1 = Roll.new
      allow(roll1).to receive(:count).with(5, true) { 5 }
      roll2 = Roll.new
      allow(roll2).to receive(:count).with(5, true) { 0 }
      roll3 = Roll.new
      allow(roll3).to receive(:count).with(5, true) { 2 }
      allow(subject).to receive(:rolls) { [roll1, roll2, roll3] }
      expect(subject.total(5)).to eq(7)
    end

    it "doesn't count ones if they're not wild" do
      roll1 = Roll.new
      expect(roll1).to receive(:count).with(5, false) { 5 }
      allow(subject).to receive(:rolls) { [roll1] }
      allow(subject).to receive(:ones_wild?) { false }
      subject.total(5)
    end
  end

  describe "#prev_bid_correct?" do
    before do
      allow(subject).to receive(:prev_bid) { Bid.new(5, 4) }
    end

    context "when the previous bid is less than the total" do
      it "returns true" do
        allow(subject).to receive(:total) { 10 }
        expect(subject.prev_bid_correct?).to be true
      end
    end

    context "when the previous bid is equal to the total" do
      it "returns true" do
        allow(subject).to receive(:total) { 5 }
        expect(subject.prev_bid_correct?).to be true
      end
    end

    context "when the previous bid is greater than the total" do
      it "returns false" do
        allow(subject).to receive(:total) { 1 }
        expect(subject.prev_bid_correct?).to be false
      end
    end
  end
end
