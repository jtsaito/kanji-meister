require "rails_helper"

describe Spa do

  let(:spa) { Spa.new }

  let(:output) do
    double Aws::DynamoDB::Types::QueryOutput,
      items: [ { css: "spa.css", js: "spa.js" } ]
  end

  before do
    allow_any_instance_of(Aws::DynamoDB::Client).to receive(:query).and_return(output)
  end

  describe "#css" do

    subject { spa.css }

    it { is_expected.to eql("https://s3.eu-central-1.amazonaws.com/kanji-meister/spa.css") }

  end

  describe "#js" do

    subject { spa.js }

    it { is_expected.to eql("https://s3.eu-central-1.amazonaws.com/kanji-meister/spa.js") }

  end

end
