require 'rails_helper'

RSpec.describe Roll, type: :model do
  let (:roll) { Roll.new(dice_string: "1-2-1-4-5") }

  describe "#dice" do
    it "returns a Hash" do
      expect(roll.dice).to be_a(Hash)
    end

    it "returns counts for each face value" do
      expect(roll.dice[1]).to eq(2)
      expect(roll.dice[2]).to eq(1)
      expect(roll.dice[3]).to eq(0)
      expect(roll.dice[4]).to eq(1)
      expect(roll.dice[5]).to eq(1)
      expect(roll.dice[6]).to eq(0)
    end
  end

  describe "#dice=" do
    it "assigns new dice values" do
      roll = Roll.new
      roll.dice = [1, 4, 2, 6]
      expect(roll.dice[1]).to eq(1)
      expect(roll.dice[2]).to eq(1)
      expect(roll.dice[3]).to eq(0)
      expect(roll.dice[4]).to eq(1)
      expect(roll.dice[5]).to eq(0)
      expect(roll.dice[6]).to eq(1)
    end
  end

  describe "#dice_count" do
    it "returns the number of dice rolled" do
      expect(Roll.new(dice_string: "1-2-1-4-5").dice_count).to eq(5)
      expect(Roll.new(dice_string: "1-2-1-4").dice_count).to eq(4)
      expect(Roll.new(dice_string: "1-2-5").dice_count).to eq(3)
      expect(Roll.new(dice_string: "4-5").dice_count).to eq(2)
      expect(Roll.new(dice_string: "1").dice_count).to eq(1)
      expect(Roll.new(dice_string: "").dice_count).to eq(0)
    end
  end

  describe "#count" do
    context "when ones are wild" do
      it "returns a count of the given face value plus ones" do
        expect(roll.count(1)).to eq(2)
        expect(roll.count(2)).to eq(3)
        expect(roll.count(3)).to eq(2)
        expect(roll.count(4)).to eq(3)
        expect(roll.count(5)).to eq(3)
        expect(roll.count(6)).to eq(2)
      end
    end

    context "when ones are not wild" do
      it "returns a count of the given face value plus ones" do
        expect(roll.count(1, false)).to eq(2)
        expect(roll.count(2, false)).to eq(1)
        expect(roll.count(3, false)).to eq(0)
        expect(roll.count(4, false)).to eq(1)
        expect(roll.count(5, false)).to eq(1)
        expect(roll.count(6, false)).to eq(0)
      end
    end
  end
end
