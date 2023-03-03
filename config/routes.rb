Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users do
        resources :clock_ins, only: [:create, :index]
      end
    end
  end
end
