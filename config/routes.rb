Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'main', to: 'main#index'

  #
  # API
  #
  namespace 'api' do
    namespace 'v1' do
      resources :users

      resources :books, only: [:create]
      resources :authors, only: [:create]
    end
  end

end
