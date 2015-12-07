BookApp::Application.routes.draw do
  resources :users, path: 'account' do
    member do
      get :confirm_email
    end
  end

  resources :sessions, only: [:new, :create, :destroy]
  resources :categories, except: [:show, :destroy]

  resources :gb, only: [:create] do
    collection do
      get :search
      get :results
    end
  end
  
  get '/signup',     to: 'users#new'
  get '/signin',     to: 'sessions#new'
  get '/blog',       to: 'static_pages#blog'
  get '/top10',      to: 'static_pages#top10'
  get '/results',    to: 'static_pages#results'
  get '/search',     to: 'static_pages#search'
  get '/signout', to: 'sessions#destroy'
  
  resources :authors, only: [:index, :new, :create]
  resources :authors, only: [:show, :edit, :update, :destroy], path: ''

  resources :authors, only: [], path: '' do
    resources :books, only: [:new, :create]
    resources :books, only: [:show, :edit, :update, :destroy], path: '' do
      resources :reviews do
        put :like
        put :dislike
      end
    end
  end

  root 'static_pages#blog'

  #unless Rails.application.config.consider_all_requests_local
  #  match '*not_found', to: 'errors#error_404'
  #end
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
