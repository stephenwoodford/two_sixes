require 'rails_helper'

require 'timecop'

shared_examples_for "a Startable" do
  describe "#start" do
    before do
      Timecop.freeze(Time.now)
      allow(obj).to receive(:after_start)
    end

    it "records the start time" do
      expect(obj.started_at).to be_nil
      obj.start
      expect(obj.started_at).to eq(Time.now)
    end

    it "calls after_start" do
      expect(obj).to receive(:after_start)
      obj.start
    end

    context "when the object has already started" do
      before do
        allow(obj).to receive(:started?) { true }
      end

      it "raises an error" do
        expect{ obj.start }.to raise_error(ArgumentError)
      end

      it "doesn't call after_start" do
        expect(obj).to_not receive(:after_start)
        begin
          obj.start
        rescue
        end
      end
    end

    after do
      Timecop.return
    end
  end

  describe "#finish" do
    before do
      Timecop.freeze(Time.now)
      allow(obj).to receive(:started?) { true }
    end

    it "records the finish time" do
      expect(obj.finished_at).to be_nil
      obj.finish
      expect(obj.finished_at).to eq(Time.now)
    end

    it "cannot be called if the object has already finished" do
      allow(obj).to receive(:finished?) { true }
      expect{ obj.finish }.to raise_error(ArgumentError)
    end

    context "when the object hasn't started" do
      before do
        allow(obj).to receive(:started?) { false }
      end

      it "raises an error" do
        expect{ obj.finish }.to raise_error(ArgumentError)
      end
    end

    after do
      Timecop.return
    end
  end

  describe "#started?" do
    it "returns true if the object has started" do
      obj.started_at = Time.now
      expect(obj.started?).to be true
    end

    it "returns false if the object hasn't started" do
      expect(obj.started?).to be false
    end
  end

  describe "#finished?" do
    it "returns true if the object has finished" do
      obj.finished_at = Time.now
      expect(obj.finished?).to be true
    end

    it "returns false if the object hasn't finished" do
      expect(obj.finished?).to be false
    end
  end

  describe "#in_progress?" do
    context "when the object has started" do
      before do
        allow(obj).to receive(:started?) { true }
      end

      it "returns false if the object has finished" do
        allow(obj).to receive(:finished?) { true }
        expect(obj.in_progress?).to be false
      end

      it "returns true if the object hasn't finished" do
        allow(obj).to receive(:finished?) { false }
        expect(obj.in_progress?).to be true
      end
    end

    context "when the object hasn't started" do
      before do
        allow(obj).to receive(:started?) { false }
      end

      it "returns false if the object hasn't finished" do
        allow(obj).to receive(:finished?) { false }
        expect(obj.in_progress?).to be false
      end
    end
  end
end
