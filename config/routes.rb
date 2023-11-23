Rails.application.routes.draw do
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
