Rails.application.routes.draw do
  get 'locations/show'
  # namespace :account do
  #   get 'users/index'
  # end
  # namespace :account do
  #   get 'bookmarks/index'
  # end
  # namespace :account do
  #   get 'reviews/index'
  # end
  
  root to: "locations#show"
  # root to: "pages#home"


  get 'pages/home'
  devise_for :users
  get 'places/map'
  get 'locations/map'

  # get "locations/:id", to: "locations#search", as: :search

  resources :locations, only: [ :index, :show ] do
    collection do
      get :search 
    end
    resources :places, only: [ :index ]
  end

  resources :places, only: [ :index, :show] do
    resources :reviews, only: [ :index, :new, :create ]
    resources :bookmarks, only: [ :create, :destroy ]
  end

  resources :bookmarks, only: [ :destroy ]

  # VOTES (created reviews index only to avoid deep nesting)
  resources :reviews do
    resources :votes, only: [ :create, :destroy]
  end

  resources :users, only: [ :show, :edit, :update ]

  namespace :account do
    resources :users, only: [ :index ]
    resources :reviews, only: [ :index ]
    resources :bookmarks, only: [ :index, :destroy ]
    # TODO: WIP ON BOOKMARK ROUTES
    # post 'bookmarks/create', to: "bookmarks#create", as: :add_bookmark
  end

  get '/tagged', to: "places#tagged", as: :tagged

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
