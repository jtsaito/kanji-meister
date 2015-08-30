module Api
  module V1
    class KanjisController < Api::BaseAPIController
      def show
        kanji = params[:random] ? Kanji.all.sample : { foo: "bar" }
        render json: kanji.to_json
      end
    end
  end
end
