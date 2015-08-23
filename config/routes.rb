Rails.application.routes.draw do
  root to: 'static_pages#home'
  get 'signup',  to: 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  

  resources :users do
      member do
          get 'favorite'
      end
  end

  resources :microposts
  resources :relationships, only: [:create, :destroy]

  resources :sessions, only: [:new, :create, :destroy]
  
   resources :favorites, only: [:create,:destroy]

end
