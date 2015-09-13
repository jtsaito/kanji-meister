Rails.application.routes.draw do
  get 'kanjis/show'

  devise_for :users

  root 'welcome#index'

  namespace :api do

    namespace :v1 do

      resources :kanjis, only: [:show, :index]

      # events should eventually be moved into a seperate service
      resources :events, only: :create

      resources :users do
        # routing has issues with combining nested resources and namespaces
        resources :tasks, only: :index, controller: 'users/tasks', action: 'index'
      end

    end

  end

end
