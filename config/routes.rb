Rails.application.routes.draw do
  # 
  # 蔵書管理の本体
  # 
  get '/', to: 'main#index', as: 'main'

  # 
  # ログイン処理
  # 
  get  '/login',  to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  get  '/logout', to: 'sessions#destroy'

  #
  # API
  #
  namespace 'api' do
    namespace 'v1' do
      resources :books, only: [:create, :index]
      get '/books/categories', to: 'books#categories'
      resources :authors, only: [:create, :index]
      resources :rentals, only: [:create, :index]
      put '/rentals/return', to: 'rentals#return_books'
    end
  end

end
