require "rails_helper"

describe Task do

  describe ".for_user" do

    subject { Task.for_user(user) }

    let(:user) { create(:user) }

    context "when the user has no kanji_rendered events" do
      it { is_expected.to be_empty }
    end

    context "when there is one kanji_rendered event" do

      let!(:event) { create(:event, :kanji_rendered, user_uuid: user.uuid) }
      let(:expected_kanji) do
        Kanji.first(:kanji, event.payload["kanji_attributes"]["kanji"])
      end

      its(:length) { is_expected.to be(1) }

      its(:first) { is_expected.to be_a(Task) }

      it "contains the right kanji" do
        expect(subject.first.kanji).to eql expected_kanji
      end

    end

  end

end
