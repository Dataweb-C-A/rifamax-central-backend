# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  post '/login', to: 'authentication#login'
  post '/social/login', to: 'authentication#social_login'
  post '/refresh', to: 'authentication#refresh'

  namespace :x100 do
    resources :orders, only: [:index] do
      get 'bill', on: :collection
    end
    resources :raffles do
      get 'progressives', on: :collection
    end
    resources :clients do
      get 'dni', on: :collection
      post 'integrator', on: :collection
    end
    resources :tickets do
      post 'sell', on: :collection
      post 'apart', on: :collection
      post 'apart_integrator', on: :collection
      post 'buy_infinite', on: :collection
      post 'clear', on: :collection
      post 'refresh', on: :collection
      post 'available', on: :collection
      post 'refund', on: :collection
      post 'combo', on: :collection
    end
    resources :draws do
      get 'raffle_stats', on: :collection
    end
    resources :invoices do
      post 'pay', on: :collection
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

  namespace :dev do
    resources :tools do
      get 'server', on: :collection
      post 'restart_server', on: :collection
    end
  end

  mount ActionCable.server => '/cable'
  mount Sidekiq::Web => '/sidekiq'
end
# rubocop:enable Metrics/BlockLength
