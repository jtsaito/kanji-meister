require 'rails_helper'

RSpec.describe Api::V1::Users::Kanjis::KanjiCommentsController, type: :controller do

  let(:user) { create(:user) }

  before do
    sign_in :user, user
  end

  describe "POST #create" do
    subject do
      post :create,
           user_uuid: user.uuid,
           kanji_character: 'k',
           text: "some_text",
           format: :json
    end

    it "200" do
      subject

      expect(response).to have_http_status(:success)
    end

    it "creates kanji comment" do
      expect { subject }.to change {
        KanjiComment.count
      }.by(1)
    end

    it "creates kanji comment with kanji character" do
      expect { subject }.to change {
        KanjiComment.where(kanji_character: 'k').count
      }.by(1)
    end

    it "creates kanji comment with user uuid" do
      expect { subject }.to change {
        KanjiComment.where(user_uuid: user.uuid).count
      }.by(1)
    end

    it "creates kanji comment with text" do
      expect { subject }.to change {
        KanjiComment.where(text: "some_text").count
      }.by(1)
    end
  end

  describe "GET #index" do
    let!(:kanji_comment) { create(:kanji_comment, user: user) }

    before do
      get :index,
        user_uuid: kanji_comment.user_uuid,
        kanji_character: kanji_comment.kanji_character,
        format: :json
    end

    subject do
      JSON.parse(response.body)
          .except("created_at", "updated_at")
          .with_indifferent_access
    end

    it "has id" do
      expect(subject[:id]).to eql(kanji_comment.id)
    end

    it "has kanji_character" do
      expect(subject[:kanji_character]).to eql(kanji_comment.kanji_character)
    end

    it "has user_uuid" do
      expect(subject[:user_uuid]).to eql(kanji_comment.user_uuid.to_s)
    end

    it "has text" do
      expect(subject[:text]).to eql(kanji_comment.text)
    end

  end

end
