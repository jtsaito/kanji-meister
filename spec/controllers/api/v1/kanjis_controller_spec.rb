require 'rails_helper'

RSpec.describe Api::V1::KanjisController, type: :controller do

  let(:user) { create(:user) }

  describe "GET #show" do

    subject { get :show, id: '九' }

    context "when user is signed in" do

      before do
        sign_in :user, user
        subject
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns http success" do
        expect(response.body).to eql(Kanji.first(:kanji, '九').to_json)
      end

    end

    context "when user is signed out" do
      it "redirects to signin" do
        subject

        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  describe "GET #index" do

    subject { get :index }

    context "when user is signed in" do
      before do
        sign_in :user, user
      end

      it "returns http success" do
        subject
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is signed out" do
      it "redirects to signin" do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

end
