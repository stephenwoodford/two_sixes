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
        expect { obj.roll_dice(p) }.to raise_error(ArgumentError)
      end
    end
  end
end
