Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users do
        resources :clock_ins, only: [:create, :index]
        member do
          delete 'clock_ins', to: 'clock_ins#destroy'
        end
      end
    end
  end
end
