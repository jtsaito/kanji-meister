require "rails_helper"

describe Task do

  let(:user) { create(:user) }

  describe ".for_user" do

    subject { Task.for_user(user) }

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

      context "with only_new param" do

        subject { Task.for_user(user, only_new: true) }

        let!(:event) { create(:event, :first_kanji_rendered, user_uuid: user.uuid) }
        let!(:second_event) { create(:event, :second_kanji_rendered, user_uuid: user.uuid) }

        let(:expected_task_list) do
          (Kanji.all - Kanji.all[0..1]).map { |k| Task.new(k.kanji) }
        end

        it { is_expected.to eql(expected_task_list) }

      end

    end

  end

  describe "#create_kanji_comment" do
    let(:task) { build(:task) }

    subject { task.create_kanji_comment(user) }

    it "creates exactly one kanji comment" do
      expect { subject }.to change { KanjiComment.count }.by 1
    end

    context "the kanji comment" do
      before do
        task.create_kanji_comment(user)
      end

      subject { KanjiComment.last }

      its(:kanji_character) { is_expected.to eql(task.kanji.kanji) }
      its(:user) { is_expected.to eql(user) }
    end
  end

end
