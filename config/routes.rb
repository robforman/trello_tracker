TrelloTracker::Application.routes.draw do

  resources :users, only: [] do
    resources :webhooks, only: [:create, :index]
    match '/webhooks', to: 'webhooks#create', via: [:head]
  end

  resource :sessions, only: [:new, :create, :destroy]
  get '/auth/:provider/callback', to: 'sessions#create'
  root 'sessions#new'

end
