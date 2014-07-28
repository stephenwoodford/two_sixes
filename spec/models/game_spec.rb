require 'rails_helper'

require 'rspec/collection_matchers'
require 'timecop'

describe Game do
  describe "#start" do
    before do
      Timecop.freeze(Time.now)
    end

    it "records the start time" do
      g = Game.new
      expect(g.started_at).to be_nil
      g.start
      expect(g.started_at).to eq(Time.now)
    end

    it "rolls each player's dice" do
      g = Game.new
      allow(g).to receive(:players) { [ Player.new, Player.new ] }
      expect(g).to receive(:roll_dice).twice
      g.start
    end

    context "when the game has already started" do
      before do
        @g = Game.new
        allow(@g).to receive(:started?) { true }
      end

      it "raises an error" do
        expect{ @g.start }.to raise_error(ArgumentError)
      end
    end

    after do
      Timecop.return
    end
  end

  describe "#finish" do
    before do
      Timecop.freeze(Time.now)
    end

    it "records the finish time" do
      g = Game.new
      g.start
      expect(g.finished_at).to be_nil
      g.finish
      expect(g.finished_at).to eq(Time.now)
    end

    it "cannot be called if the game has already finished" do
      g = Game.new
      allow(g).to receive(:started?) { true }
      allow(g).to receive(:finished?) { true }
      expect{ g.finish }.to raise_error(ArgumentError)
    end

    it "cannot be called if the game hasn't started" do
      g = Game.new
      expect{ g.finish }.to raise_error(ArgumentError)
    end

    after do
      Timecop.return
    end
  end

  describe "#started?" do
    it "returns true if the game has started" do
      g = Game.new
      g.started_at = Time.now
      expect(g.started?).to be true
    end

    it "returns false if the game hasn't started" do
      g = Game.new
      expect(g.started?).to be false
    end
  end

  describe "#finished?" do
    it "returns true if the game has finished" do
      g = Game.new
      g.finished_at = Time.now
      expect(g.finished?).to be true
    end

    it "returns false if the game hasn't finished" do
      g = Game.new
      expect(g.finished?).to be false
    end
  end

  describe "#in_progress?" do
    let (:g) { Game.new }

    context "when the game has started" do
      before do
        allow(g).to receive(:started?) { true }
      end

      it "returns false if the game has finished" do
        allow(g).to receive(:finished?) { true }
        expect(g.in_progress?).to be false
      end

      it "returns true if the game hasn't finished" do
        allow(g).to receive(:finished?) { false }
        expect(g.in_progress?).to be true
      end
    end

    context "when the game hasn't started" do
      before do
        allow(g).to receive(:started?) { false }
      end

      it "returns false if the game hasn't finished" do
        allow(g).to receive(:finished?) { false }
        expect(g.in_progress?).to be false
      end
    end
  end

  describe "#roll_dice" do
    it "rolls the correct number of dice" do
      g = Game.new
      p = Player.new(dice_count: 5)
      roll = g.roll_dice(p)
      expect(roll.dice_count).to eq(5)
      p = Player.new(dice_count: 2)
      roll = g.roll_dice(p)
      expect(roll.dice_count).to eq(2)
    end
  end
end
