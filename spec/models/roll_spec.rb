require 'rails_helper'

RSpec.describe Roll, type: :model do
  let (:roll) { Roll.new(dice_string: "1-2-1-4-5") }

  describe "#dice" do
    it "returns an Array" do
      expect(roll.dice).to be_a(Array)
    end

    it "contains all of the dice in dice_string" do
      expect(roll.dice.count).to eq(5)
      expect(roll.dice).to match_array([1, 2, 1, 4, 5])
    end
  end

  describe "#dice_hash" do
    it "returns a Hash" do
      expect(roll.dice_hash).to be_a(Hash)
    end

    it "returns counts for each face value" do
      expect(roll.dice_hash[1]).to eq(2)
      expect(roll.dice_hash[2]).to eq(1)
      expect(roll.dice_hash[3]).to eq(0)
      expect(roll.dice_hash[4]).to eq(1)
      expect(roll.dice_hash[5]).to eq(1)
      expect(roll.dice_hash[6]).to eq(0)
    end
  end

  describe "#dice=" do
    it "assigns new dice values" do
      roll = Roll.new
      roll.dice = [1, 4, 2, 6]
      expect(roll.dice_hash[1]).to eq(1)
      expect(roll.dice_hash[2]).to eq(1)
      expect(roll.dice_hash[3]).to eq(0)
      expect(roll.dice_hash[4]).to eq(1)
      expect(roll.dice_hash[5]).to eq(0)
      expect(roll.dice_hash[6]).to eq(1)
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
