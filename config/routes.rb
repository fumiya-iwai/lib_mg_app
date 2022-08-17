Rails.application.routes.draw do
  get '/', to: 'sessions#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'main', to: 'main#index'

  #
  # API
  #
  namespace 'api' do
    namespace 'v1' do
      resources :users

      resources :books, only: [:create, :index]
      resources :authors, only: [:create, :index]
      resources :rentals, only: [:create, :index]
      put '/rentals/return', to: 'rentals#return_books'
    end
  end

end
