require_relative '../../lib/reportier/defaults'

RSpec.describe Reportier::Defaults do
  let(:defaults) { described_class.new }

  it "initialized all default values" do
    expect(defaults.instance_variables).to include \
      :@trackers, :@reporting_vars, :@reporters, :@persister
  end

  it "set corrent values" do
    expect(defaults.trackers).to          eq Hash.new
    expect(defaults.reporters).to      eq Hash.new
    expect(defaults.reporting_vars).to eq Hash.new
    expect(defaults.persister).to      eq :memory
  end

  it "can update reporting_vars" do
    defaults.update_reporting_vars kangaroos: 3, \
      prime_numbers: Float::INFINITY

    expect(defaults.reporting_vars).to include \
      kangaroos: 3, prime_numbers: Float::INFINITY
  end

  describe "global default configuration" do
    let(:defaults) { described_class.global }

    before do
      defaults.configure do |c|
        c.trackers          = { minutely: 60 }
        c.reporting_vars = { potatoes: 7 }
        c.reporters      = { logger: 'logger' }
        c.persister      = :redis
      end
    end

    it "can be configured" do
      expect(defaults.reporting_vars).to include potatoes: 7
      expect(defaults.trackers).to          include minutely: 60
      expect(defaults.reporters).to      include logger: 'logger'
      expect(defaults.persister).to      eq :redis
    end

    after do
      class Reportier::Defaults 
        @global = new
      end
    end


  end
end
