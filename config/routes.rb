# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'pages#homepage' # this renders homepage at "/"
  get 'homepage', to: 'pages#homepage'
end
