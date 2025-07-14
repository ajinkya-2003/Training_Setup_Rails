Rails.application.routes.draw do
  root 'pages#homepage'               # this renders homepage at "/"
  get 'homepage', to: 'pages#homepage'
end
