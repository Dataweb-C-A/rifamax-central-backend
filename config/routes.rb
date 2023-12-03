# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  # mount Sidekiq::Web, to: '/sidekiq'

  post '/login', to: 'authentication#login'

  namespace :x100 do
    resources :raffles
    resources :clients
  end

  namespace :rifamax do
    resources :tickets
    resources :raffles
  end
  namespace :fifty do
    resources :stadia
    resources :locations
  end
  namespace :shared do
    resources :users
  end
end
