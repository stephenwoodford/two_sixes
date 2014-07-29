require 'rails_helper'

require_relative '../lib/startable_spec'

describe Game do
  let (:obj) { Game.new }

  it_behaves_like "a Startable"

  describe "#before_start" do
    it "seats the players" do
      expect(obj).to receive(:seat_players)
      obj.before_start
    end
  end

  describe "#after_start" do
    it "starts a round" do
      expect(obj).to receive(:start_round)
      obj.after_start
    end
  end

  describe "#start_round" do
    before do
      allow(obj).to receive(:in_progress?) { true }
      allow_any_instance_of(Round).to receive(:start)
      allow(obj).to receive(:add_event)
    end

    context "when there's an existing round" do
      it "uses the next round number" do
        allow(obj).to receive(:round){ Round.new(number: 4) }
        expect(obj.rounds).to receive(:create).with(number: 5) { Round.new }
        obj.start_round
      end
    end

    context "when there's not an existing round" do
      it "uses round number 0" do
        allow(obj).to receive(:round){ nil }
        expect(obj.rounds).to receive(:create).with(number: 0) { Round.new }
        obj.start_round
      end
    end

    context "when the game isn't in progress" do
      before do
        allow(obj).to receive(:in_progress?) { false }
      end

      it "raises an error" do
        expect { obj.start_round }.to raise_error(UsageError)
      end
    end
  end

  describe "#add_event" do
    context "when there's an existing game event" do
      it "uses the next event number" do
        allow(obj).to receive(:last_event){ GameEvent.new(number: 4) }
        expect(obj.game_events).to receive(:create).with(a_hash_including(number: 5)) { GameEvent.new }
        obj.add_event(Roll.new)
      end
    end

    context "when there's not an existing round" do
      it "uses round number 0" do
        allow(obj).to receive(:last_event){ nil }
        expect(obj.game_events).to receive(:create).with(a_hash_including(number: 0)) { GameEvent.new }
        obj.add_event(Roll.new)
      end
    end
  end

  describe "#add_player" do
    context "when the game has started" do
      it "raises an error" do
        allow(obj).to receive(:started?) { true }
        expect{obj.add_player(User.new, "Handle")}.to raise_error(UsageError)
      end
    end
  end

  describe "#seat_players" do
    context "when the game has started" do
      it "raises an error" do
        allow(obj).to receive(:started?) { true }
        expect{obj.seat_players}.to raise_error(UsageError)
      end
    end

    it "assigns seats to players" do
      players = [Player.new, Player.new, Player.new]
      allow(obj).to receive(:players) { players }
      obj.seat_players
      expect(players.map(&:seat)).to all(be_present)
    end
  end
end
