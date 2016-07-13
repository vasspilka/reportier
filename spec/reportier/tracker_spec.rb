require_relative '../../lib/reportier'

RSpec.describe Reportier::Tracker do

  describe "class methods" do
    it "should return appropriate type with [] method" do
      tracker =  described_class[:some_type]
      expect(tracker.type).to eq :some_type
    end
  end

  describe "simple tracker" do
    let(:tracker) { described_class.new }
    subject { tracker }


    it "should report instantly withot adding item" do
      expect(subject).to receive(:report)
      subject.add 'item'
      expect(subject.persister.reporting_vars).to be_empty
      expect(subject.to_json).to eq "{}"
    end

    it "should receive clear" do
      expect(subject).to receive(:clear)
      subject.add 'item'
    end

    it "clear should change @started_at" do
      expect{subject.send(:clear)}.to change { subject.started_at }
    end
  end

  describe "daily tracker" do
    it "keeps track of stuff" do
    end
    it "expires exactly one day after it's been created" do
    end
  end
end
