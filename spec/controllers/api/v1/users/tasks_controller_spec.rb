require 'rails_helper'

RSpec.describe Api::V1::Users::TasksController, type: :controller do

  describe "GET #index" do
    let(:user) { create(:user) }

    context "when the user is signed in" do
      before do
        sign_in :user, user
      end

      it "gives 200" do
        get :index, user_id: user.uuid

        expect(response).to have_http_status(:success)
      end

      it "returns stuff" do
        #get :index, show_params
      end
    end
  end

end
