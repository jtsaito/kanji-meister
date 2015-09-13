module Api
  module V1
    module Users
      class TasksController < ApplicationController
        protect_from_forgery except: :index

        def index
          user = User.find_by_uuid(params[:user_id])

          render json: Task.for_user(user).to_json
        end
      end
    end
  end
end
