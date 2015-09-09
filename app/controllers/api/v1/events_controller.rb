module Api
  module V1
    class EventsController < ApplicationController
      protect_from_forgery except: :create

      def create
        Event.create!(event_params)

        render json: params.to_json
      end

      private

      def event_params
        params.require(:event)
              .permit(:name, :user_uuid)
              .merge(payload: Hash[params[:event][:payload]])
      end
    end
  end
end
