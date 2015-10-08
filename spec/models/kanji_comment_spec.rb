require 'rails_helper'

RSpec.describe KanjiComment, type: :model do

  describe ".create!" do
    subject { described_class.create!(attributes) }

    let(:attributes) do
      { kanji_character: kanji_character, user: user, text: text }
    end

    let(:kanji_character) { Kanji.all.first.kanji }
    let(:user) { create(:user) }
    let(:text) { SecureRandom.hex(255) }

    it { is_expected.to be_a(described_class) }

    its(:text) { should eql(text) }

    context "without kanji" do
      let(:kanji_character) { nil }

      it "raises" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "without user" do
      let(:user) { nil }

      it "raises" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
