require 'rails_helper'

require_relative '../lib/startable_spec'

describe Game do
  subject { Game.new }

  it_behaves_like "a Startable"

  describe "#before_start" do
    it "seats the players" do
      is_expected.to receive(:seat_players)
      subject.before_start
    end
  end

  describe "#after_start" do
    it "starts a round" do
      is_expected.to receive(:start_round)
      subject.after_start
    end
  end

  describe "#start_round" do
    before do
      allow(subject).to receive(:in_progress?) { true }
      allow_any_instance_of(Round).to receive(:start)
      allow(subject).to receive(:add_event)
    end

    context "when there's an existing round" do
      it "uses the next round number" do
        allow(subject).to receive(:round){ Round.new(number: 4) }
        expect(subject.rounds).to receive(:create).with(number: 5) { Round.new }
        subject.start_round
      end
    end

    context "when there's not an existing round" do
      it "uses round number 0" do
        allow(subject).to receive(:round){ nil }
        expect(subject.rounds).to receive(:create).with(number: 0) { Round.new }
        subject.start_round
      end
    end

    context "when the game isn't in progress" do
      before do
        allow(subject).to receive(:in_progress?) { false }
      end

      it "raises an error" do
        expect { subject.start_round }.to raise_error(UsageError)
      end
    end
  end

  describe "#add_event" do
    context "when there's an existing game event" do
      it "uses the next event number" do
        allow(subject).to receive(:last_event){ GameEvent.new(number: 4) }
        expect(subject.game_events).to receive(:create).with(a_hash_including(number: 5)) { GameEvent.new }
        subject.add_event(Roll.new)
      end
    end

    context "when there's not an existing round" do
      it "uses round number 0" do
        allow(subject).to receive(:last_event){ nil }
        expect(subject.game_events).to receive(:create).with(a_hash_including(number: 0)) { GameEvent.new }
        subject.add_event(Roll.new)
      end
    end
  end

  describe "#add_player" do
    context "when the game has started" do
      it "raises an error" do
        allow(subject).to receive(:started?) { true }
        expect{subject.add_player(User.new, "Handle")}.to raise_error(UsageError)
      end
    end
  end

  describe "#seat_players" do
    context "when the game has started" do
      it "raises an error" do
        allow(subject).to receive(:started?) { true }
        expect{subject.seat_players}.to raise_error(UsageError)
      end
    end

    it "assigns seats to players" do
      players = [Player.new, Player.new, Player.new]
      allow(subject).to receive(:players) { players }
      subject.seat_players
      expect(players.map(&:seat)).to all(be_present)
    end
  end
end
