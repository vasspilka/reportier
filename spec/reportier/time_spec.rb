require_relative '../../lib/reportier/time'

RSpec.describe Reportier::Time do

  before { extend Reportier::Time }

  it "can calculate time" do
    expect(seconds(1)).to eq 1
    expect(minutes(1)).to eq 60
    expect(hours  (1)).to eq 3600
    expect(days   (1)).to eq 86400
    expect(weeks  (1)).to eq 604800
    expect(months (1)).to eq 2592000
    expect(years  (1)).to eq 31557600
  end
end
