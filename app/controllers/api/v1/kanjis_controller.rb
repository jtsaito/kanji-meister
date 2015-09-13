module Api
  module V1
    class KanjisController < Api::BaseAPIController
      def index
        render json: Kanji.all.sample.to_json
      end

      def show
        render json: Kanji.first(:kanji, params[:id]).to_json
      end
    end
  end
end
