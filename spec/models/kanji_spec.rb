require "rails_helper"

describe Kanji do
  describe ".by" do
    subject { Kanji.by(attribute, value) }

    context "when looking up by heisig_id" do
      let(:attribute) { :heisig_id }
      let(:value) { 1455 }

      it "finds with kanji" do
        expect(subject.map(&:kanji)).to eql(["鑑"])
      end

      it "finds with key word " do
        expect(subject.map(&:key_word)).to eql(["specimen"])
      end
    end

    context "when looking up by kanji" do
      let(:attribute) { :kanji }
      let(:value) { "襲" }

      it "finds with heisig id" do
        expect(subject.map(&:heisig_id)).to eql([2025.to_s])
      end

      it "finds with heisig lesson" do
        expect(subject.map(&:heisig_lesson)).to eql([55.to_s])
      end
    end

    context "when looking by non-existing attribute" do
      let(:attribute) { :foo }
      let(:value) { 1455 }

      it "raises error" do
        expect { subject }.to raise_error(Kanji::UnknownAttributeError)
      end
    end
  end
end
