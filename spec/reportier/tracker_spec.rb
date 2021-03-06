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
      expect(subject.to_hash).to be_empty
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
        c.trackers          = { minutely: 60 }
      end
    end

    it "expires exactly one minute after it's been created" do
      expect(subject.active?).to eq true
      expect(subject.send(:expires_at)).to eq (subject.started_at + 60)
    end

    it "keeps track of stuff and can clear them" do
      subject.add 'item'
      expect(subject.to_hash).not_to be_empty
      expect(subject.to_hash[:items]).to eq 1
      subject.add 'item'
      subject.add 'item'
      expect(subject.to_hash[:items]).to eq 3

      subject.persister.clear
      expect(subject.to_hash).to be_empty
    end

    it "will not remmeber stuff" do
      tracker = described_class[:minutely]
      tracker.add 'item'
      tracker = described_class.new(type: :minutely)

      expect(tracker.to_hash).to be_empty
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
        expect(subject.to_hash).not_to be_empty
        expect(subject.to_hash[:items]).to eq 1
        subject.add 'item'
        subject.add 'item'
        expect(subject.to_hash[:items]).to eq 3

        subject.persister.clear
        expect(subject.to_hash).to be_empty
      end

      it "will remember its attributes" do
        tracker = described_class[:minutely]
        tracker.add 'item'
        tracker = described_class.new(type: :minutely)

        expect(tracker.persister.to_hash[:items]).to eq 1

        tracker.persister.clear
      end

      it "will keep the same started_at date" do
        tracker      = described_class[:minutely]
        same_tracker = described_class.new(type: :minutely)
        expect(tracker.started_at).to be_kind_of DateTime
        expect(tracker.started_at).to eq same_tracker.started_at
      end

      describe "with default vars" do
        it "initializes with default reporting vars" do
          Reportier.configure do |c|
            c.update_reporting_vars({ bananas: 5 })
          end
          tracker = described_class.new(name: 'Bananas')
          expect(tracker.to_hash[:bananas]).to eq 5
        end
      end
    end

    after do
      class Reportier::Defaults
        @global = new
      end
      class Reportier::Tracker
        @current[:minutely] = nil
      end
    end

  end
end
