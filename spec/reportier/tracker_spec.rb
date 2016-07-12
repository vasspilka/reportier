require_relative '../../lib/reportier'

RSpec.describe Reportier::Tracker do

  describe "simple tracker" do
    let(:tracker) { described_class.new }
    subject { tracker }

    it "should report instantly withot adding item" do
      expect(subject).to receive(:report)
      tracker.add 'item'
      require "pry"; binding.pry
      expect(subject.persister.reporting_vars).to \
        be_empty
    end



  end
end
