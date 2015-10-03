module Api
  module V1
    module Users
      class TasksController < ApplicationController
        protect_from_forgery except: :index

        def index
          user = User.find_by_uuid(params[:user_uuid])

          render json: Task.for_user(user, only_new: params[:only_new]).to_json
        end
      end
    end
  end
end
