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
      expect(subject.persister.to_hash).to be_empty
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

  describe "minutely tracker" do
    let(:tracker) { described_class[:minutely] }
    subject { tracker }

    before do
      Reportier.configure do |c|
        c.types          = { minutely: 60 }
      end
    end

    it "expires exactly one minute after it's been created" do
      expect(subject.active?).to eq true
      expect(subject.send(:expires_at)).to eq (subject.started_at + 60)
    end

    it "keeps track of stuff and can clear them" do
      subject.add 'item'
      expect(subject.persister.to_hash).not_to be_empty
      expect(subject.persister.to_hash[:items]).to eq 1
      subject.add 'item'
      subject.add 'item'
      expect(subject.persister.to_hash[:items]).to eq 3

      subject.persister.clear
      expect(subject.persister.to_hash).to be_empty
    end

    describe "with redis" do
      before do
        require 'redis'
        Reportier.configure do |c|
          c.persister     = :redis
        end
      end

      it "keeps track of stuff and can clear them" do
        subject.add 'item'
        expect(subject.persister.to_hash).not_to be_empty
        expect(subject.persister.to_hash[:items]).to eq 1
        subject.add 'item'
        subject.add 'item'
        expect(subject.persister.to_hash[:items]).to eq 3

        subject.persister.clear
        expect(subject.persister.to_hash).to be_empty
      end
    end

    after do
      class Reportier::Defaults
        @global = new
      end
      class Reportier::Tracker
        @current[:minutely] = nil
      end
      subject.persister.clear
    end

  end
end
