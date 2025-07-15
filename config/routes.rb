# frozen_string_literal: true

Rails.application.routes.draw do
  apipie

  devise_for :users

  root 'pages#homepage'
  get 'homepage', to: 'pages#homepage'

  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :create]
    end
  end
end
