require 'rails_helper'

require 'timecop'

shared_examples_for "a Startable" do
  describe "#start" do
    before do
      Timecop.freeze(Time.now)
      allow(subject).to receive(:after_start)
    end

    it "records the start time" do
      expect(subject.started_at).to be_nil
      subject.start
      expect(subject.started_at).to eq(Time.now)
    end

    it "calls after_start" do
      is_expected.to receive(:after_start)
      subject.start
    end

    context "when the subject has already started" do
      before do
        allow(subject).to receive(:started?) { true }
      end

      it "raises an error" do
        expect{ subject.start }.to raise_error(ArgumentError)
      end

      it "doesn't call after_start" do
        is_expected.to_not receive(:after_start)
        begin
          subject.start
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
      allow(subject).to receive(:started?) { true }
      allow(subject).to receive(:after_finish)
    end

    it "records the finish time" do
      expect(subject.finished_at).to be_nil
      subject.finish
      expect(subject.finished_at).to eq(Time.now)
    end

    it "cannot be called if the subject has already finished" do
      allow(subject).to receive(:finished?) { true }
      expect{ subject.finish }.to raise_error(ArgumentError)
    end

    context "when the subject hasn't started" do
      before do
        allow(subject).to receive(:started?) { false }
      end

      it "raises an error" do
        expect{ subject.finish }.to raise_error(ArgumentError)
      end
    end

    after do
      Timecop.return
    end
  end

  describe "#started?" do
    it "returns true if the subject has started" do
      subject.started_at = Time.now
      expect(subject.started?).to be true
    end

    it "returns false if the subject hasn't started" do
      expect(subject.started?).to be false
    end
  end

  describe "#finished?" do
    it "returns true if the subject has finished" do
      subject.finished_at = Time.now
      expect(subject.finished?).to be true
    end

    it "returns false if the subject hasn't finished" do
      expect(subject.finished?).to be false
    end
  end

  describe "#in_progress?" do
    context "when the subject has started" do
      before do
        allow(subject).to receive(:started?) { true }
      end

      it "returns false if the subject has finished" do
        allow(subject).to receive(:finished?) { true }
        expect(subject.in_progress?).to be false
      end

      it "returns true if the subject hasn't finished" do
        allow(subject).to receive(:finished?) { false }
        expect(subject.in_progress?).to be true
      end
    end

    context "when the subject hasn't started" do
      before do
        allow(subject).to receive(:started?) { false }
      end

      it "returns false if the subject hasn't finished" do
        allow(subject).to receive(:finished?) { false }
        expect(subject.in_progress?).to be false
      end
    end
  end
end
