Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      resources :users, only: [:create] do
        post '/users/:id/follow', to: "users#follow", as: "follow_user"
        post '/users/:id/unfollow', to: "users#unfollow", as: "unfollow_user"

        resources :clock_ins, only: [:create, :index] do
          collection do
            delete '', to: 'clock_ins#destroy', as: 'clock_ins'
          end
        end
      end
    end
  end

  match '*unmatched', to: 'application#not_found_method', via: :all
end

