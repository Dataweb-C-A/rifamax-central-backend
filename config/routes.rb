# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  post '/login', to: 'authentication#login'

  namespace :x100 do
    resources :orders, only: [:index] do 
      get 'bill', on: :collection
    end
    resources :raffles do
      get 'progressives', on: :collection
    end
    resources :clients do 
      post 'integrator', on: :collection
    end
    resources :tickets do
      post 'sell', on: :collection
      post 'apart', on: :collection
      post 'refresh', on: :collection
      post 'available', on: :collection
    end
    resources :draws do 
      get 'raffle_stats', on: :collection
    end
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
    resources :exchanges
    resources :users do
      get 'profile', on: :collection
    end
  end

  mount ActionCable.server => '/cable'
  mount Sidekiq::Web => '/sidekiq'
end
