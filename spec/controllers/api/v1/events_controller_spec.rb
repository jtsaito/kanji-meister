require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :controller do

  describe "GET #create" do
    let(:user) { create(:user) }
    let(:create_params) do
      {
        event: {
            name: "event-name",
            user_uuid: user.uuid.to_s,
            payload: { foo: 1, bar: "baz" }
        }
      }
    end

    context "when the user is signed in" do
      before do
        sign_in :user, user
      end

      it "returns http success" do
        post :create, create_params

        expect(response).to have_http_status(:success)
      end

      it "creates a new event" do
        expect(Event).to receive(:create!).with("name" => "event-name",
                                                "user_uuid" => user.uuid.to_s,
                                                "payload" => { "foo" => "1", "bar" => "baz" })

        post :create, create_params
      end
    end
  end

end
