module Api

  module V1

    module Users

      module Kanjis

        class KanjiCommentsController < ::Api::BaseAPIController
          protect_from_forgery except: :index

          def show
            kanji_comment = KanjiComment.where(create_params).first!

            respond_to do |format|
              format.json { render json: kanji_comment }
            end
          end

          def create
            KanjiComment.create!(create_params)

            respond_to do |format|
              format.json { head :ok }
            end
          end

          def index
            respond_to do |format|
              format.json { render json: KanjiComment.where(index_params).first }
            end
          end

          def update
            KanjiComment.find(params.require(:id))
                        .update!(update_params)

            respond_to do |format|
              format.json { head :ok }
            end
          end

          private

          def index_params
            params.permit(:user_uuid, :kanji_character)
          end

          def create_params
            params.permit(:user_uuid, :kanji_character, :text)
          end

          def update_params
            params.permit(:id, :text).slice(:id, :text)
          end

        end

      end

    end

  end

end
