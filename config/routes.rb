Rails.application.routes.draw do
  # Devise routes with custom sessions controller
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  # Root and homepage
  root 'pages#homepage'
  get 'homepage', to: 'pages#homepage'

  # Avatar and profile management
  resource :avatar, only: [:edit, :update, :destroy]
  get    'profile/edit',   to: 'users#edit_profile',   as: :edit_profile
  patch  'profile/update', to: 'users#update_profile', as: :update_profile

  # Restaurants and their nested restaurant tables
  resources :restaurants do
    resources :restaurant_tables, path: 'tables'
  end

  # API
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :create, :show, :update, :destroy]
    end
  end

  # API documentation (Apipie)
  apipie
end
