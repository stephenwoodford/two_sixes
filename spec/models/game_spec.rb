require 'rails_helper'

require_relative '../lib/startable_spec'

describe Game do
  let (:obj) { Game.new }

  it_behaves_like "a Startable"

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
        expect { obj.start_round }.to raise_error(ArgumentError)
      end
    end
  end
end
