require 'rails_helper'

RSpec.describe Api::V1::KanjisController, type: :controller do

  describe "GET #index" do

    let(:user) { create(:user) }

    context "when user is signed in" do
      before do
        sign_in :user, user
      end

      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is signed out" do
      it "redirects to signin" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

end
