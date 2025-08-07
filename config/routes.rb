Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  scope :api do
    scope :v1 do
      resources :frames, only: [ :create, :destroy, :show ] do
        resources :circles, only: [ :create, :destroy, :update ], shallow: true
      end

      resources :circles, only: [ :index ]
    end
  end
end
