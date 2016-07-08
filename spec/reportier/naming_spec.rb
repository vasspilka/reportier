require_relative '../../lib/reportier/naming'

RSpec.describe Reportier::Namer do
  let(:insecure_string) { "valid name;\n puts 'you have been hacked'\"p 'haha'\"" }
  let(:string)   { "some item" }

  subject { described_class.new }

  it "secures a string" do
    expect(subject.name_class(insecure_string)).to eq \
      "ValidNamePutsYouHaveBeenHackedpHaha"
    expect(subject.name_item(insecure_string)).to eq \
      "valid_name__puts_you_have_been_hackedp_hahas"
    expect(subject.name(insecure_string)).to eq \
      "valid_name__puts_you_have_been_hackedp_haha"
  end

  it "names the string" do
    expect(subject.name_class(string)).to eq "SomeItem"
    expect(subject.name_item(string)).to  eq "some_items"
    expect(subject.name(string)).to       eq "some_item"

  end
end
