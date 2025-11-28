Rails.application.routes.draw do
  resources :institutions, only: [:new, :create]

  # scope '/:tenant' do
  #   resources :courses
  #   resources :students
  #   resources :teachers
  #   # … all your routes

  # end

  devise_scope :user do
    authenticated :user do
      root to: "students/courses#index", as: :authenticated_root
    end
  
    unauthenticated do
      root to: "users/sessions#new", as: :unauthenticated_root
    end
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  
  namespace :instructors do
    get "onboarding/refresh"
    get "onboarding/return"
    resources :courses
    resource :profile, only: [:show, :edit, :update]
    root "courses#index" 
    get "onboarding/refresh", to: "onboarding#refresh"
    get "onboarding/return", to: "onboarding#return"
    get "onboarding/onboard_account", to: "onboarding#onboard_account"
  end
  namespace :students do

    resources :cart_items
    get "checkouts/success", to: "checkouts#success"
    resources :checkouts, only: [:create]
    resources :enrollments
    resources :interviews, only: [] do
      collection do
        get  :language
        post :start
        post :answer
        get  :finish
        get  :ask
      end
      member do
        get :stream_question    
      end
    end
    resources :carts,only: [:show, :index,:create] 
    resources :courses, only: [:show, :index]
    root "enrollments#index" 
  end
  post "/webhooks/stripe", to: "webhooks#stripe"

end
