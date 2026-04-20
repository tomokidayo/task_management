Rails.application.routes.draw do
  get "chat_messages/create"
  get "chat_sessions/index"
  get "chat_sessions/show"
  get "chat_sessions/create"
  get "tasks/index"
  get "tasks/new"
  get "tasks/create"
  get "tasks/edit"
  get "tasks/update"
  get "tasks/destroy"
  get "tasks/show"
  devise_for :users
  get "home/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # root to: "home#index"
  # root to: "devise/sessions#new"
  devise_scope :user do
    root to: "devise/sessions#new"
  end

  # root "tasks#index"
  resources :tasks


  resources :tasks do
    patch :update_status, on: :member
  end

  resources :chat_sessions, only: [ :index, :show, :create ]


  resources :chat_sessions, only: [ :index, :show, :create ] do
    resources :chat_messages, only: [ :create ]
  end

  resources :chat_sessions, only: [ :index, :show, :create ] do
    resources :chat_messages, only: [ :create ]
  end


  # Defines the root path route ("/")
  # root "posts#index"
  resource :mypage, only: [ :show, :edit, :update ]
end
