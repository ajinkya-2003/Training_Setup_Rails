# frozen_string_literal: true

Rails.application.routes.draw do
  # Avatar management (edit, update, delete)
  resource :avatar, only: [:edit, :update, :destroy]

  # Apipie documentation
  apipie

  # Devise routes for authentication
  devise_for :users

  # Homepage
  root 'pages#homepage'
  get 'homepage', to: 'pages#homepage'

  # Profile management (edit personal data without password)
  get 'profile/edit', to: 'users#edit_profile', as: :edit_profile
  patch 'profile/update', to: 'users#update_profile', as: :update_profile

  # Restaurant routes (added for sidebar links)
  resources :restaurants

  # API namespace
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :create, :show, :update, :destroy]
    end
  end
end
