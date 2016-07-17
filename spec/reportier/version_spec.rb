require_relative '../../lib/reportier/version.rb'

describe Reportier do
  it "has a version number" do
    expect(Reportier::VERSION).not_to eq nil
  end
end
