require 'rails_helper'

describe User do
  describe "#name" do
    context "when the name attribute is set" do
      it "returns the user's name" do
        u = User.create(email: "foo@example.com", name: "foo")
        expect(u.name).to eq("foo")
      end
    end

    context "when the name attribute is an empty string" do
      it "returns the user's email" do
        u = User.create(email: "foo@example.com", name: "")
        expect(u.name).to eq("foo@example.com")
      end
    end

    context "when the name attribute is nil" do
      it "returns the user's name" do
        u = User.create(email: "foo@example.com")
        expect(u.name).to eq("foo@example.com")
      end
    end
  end

  describe "#claim_invites" do
    it "sets the user on all invites for the user's email" do
      u = User.create(email: "foo@example.com", password: "foobar")

      game = Game.create
      game.game_invites.create(email: "foo@example.com")
      game.game_invites.create(email: "bar@example.com")

      expect(u.game_invites.count).to eq(0)
      u.claim_invites
      expect(u.game_invites.count).to eq(1)
      expect(u.game_invites.first.email).to eq("foo@example.com")
    end
  end
end
