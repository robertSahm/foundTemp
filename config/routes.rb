Drinkboard::Application.routes.draw do
  
  root to: 'users#new'
  resources :locations

  resources :employees
  match "/invite/:id" => "invite#show"
  
  resources :orders
  resources :redeems
  resources :gifts do
    collection do
      get  'buy'
      get  'activity'
      get  'browse'
      post 'browse_with_contact'
      post 'browse_with_location'
      post 'choose_from_menu'
      post 'choose_from_contacts'
      post 'bill'
      get  'past'
    end
    member do
      get 'detail'
      get 'completed'
    end
  end

  resources :providers 
  
  # resources :providers, :as => "establishments"
  # providers should really be merchant side and merchant should be establishments
  # could make an establishment controller for user side 
  
  resources :merchants do
    member do
      get 'past_orders'
      get 'detail'
      get 'customers'
      get 'orders'
      get 'order'
      get 'completed'
      get 'staff'
    end
  end
  
  resources :items
  resources :menus
  resources :menu_strings

  resources :connections, only: [:create, :destroy]
  resources :sessions,    only: [:new, :create, :destroy]
  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy'
  resources :admins, only: [:new, :create, :destroy]

  
  ###  mobile app routes
  match 'app/create_account',   to: 'iphone#create_account',   via: :post
  match 'app/login',            to: 'iphone#login',            via: :post
  match 'app/gifts',            to: 'iphone#gifts',            via: :post
  match 'app/buys',             to: 'iphone#buys',             via: :post
  match 'app/activity',         to: 'iphone#activity',         via: :post
  match 'app/provider',         to: 'iphone#provider',         via: :post
  match 'app/locations',        to: 'iphone#locations',        via: :post
  match 'app/buy_gift',         to: 'iphone#create_gift',      via: :post
  match 'app/redeem',           to: 'iphone#create_redeem',    via: :post
  match 'app/order',            to: 'iphone#create_order',     via: :post
  match 'app/users',            to: 'iphone#drinkboard_users', via: :post
  match 'app/photo',            to: 'iphone#update_photo',     via: :post 
  match 'app/merchant/active',  to: 'iphone#active_orders',    via: :post
  match 'app/merchant/complete',to: 'iphone#completed_orders', via: :post
  
  ###
  # match '/drinkboard', to: 'gifts#activity'
  match '/about',       to: 'home#about'
  match '/contact',     to: 'home#contact'
  match '/home',        to: 'home#index'
  match '/learn',       to: 'home#learn'
  match '/news',        to: 'home#news'
  # match '/browse', to: 'gifts#browse'
  
  ### authentication via Facebook & Foursquare
  match '/facebook/oauth',    to: 'oAuth#loginWithFacebook'
  match '/foursquare/oauth',  to: 'oAuth#loginWithFoursquare'
  ###
  
  ##Location resources
  match '/map', to: 'locations#map'
  match '/map/boundary', to: 'locations#mapForUserWithinBoundary'
  
  resources :microposts,    only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  
  resources :users do 
    member do
      get :following, :followers
      get :servercode
      get :crop
    end
  end
  


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
