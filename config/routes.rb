KimbraStudio::Application.routes.draw do

  match 'auth/:provider/callback', to: 'facebook_sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'facebook_signout', to: 'facebook_sessions#destroy', as: 'facebook_signout'

  ActiveAdmin.routes(self)

  root :to => "welcome#index"

  resources :facebook_sessions, only: [:create, :destroy] do
    member do
      post :share
      post :like
    end


  end

  resource :about do
    get :show
    get :signup
    get :contact
  end

  namespace :admin do
    namespace :customer do
      resources :emails do
        collection do
          post :send_all_offers
        end
        member do
          post :generate
          get :session_list
          post :send_offers
        end
        resources :offers do
          resources :items
        end
      end
    end
    namespace :merchandise do
      resources :pieces do
        resources :parts
      end
    end
    resource :overview, :only => [:show]
    match "stories/fetch", controller: :stories, action: :fetch
    resources :stories
  end

  resources :categories # studio session categories
  resources :countries
  resources :image_layouts

  namespace :minisite do
    resources :emails do
      member do
        get :about
        get :contact
        get :order_status, path: 'order_status/:cart'
        get :privacy
        get :returns
        get :unsubscribe
      end
      resources :offers do
        collection do
          get :index_chains
          get :index_charms
        end

      end
      resources :portraits
    end
    resources :item_sides do
          member do
            get :portrait, path: 'portrait/:portrait_id(.:format)'
            get :stock, path: 'stock/:item_side_id(.:format)'
          end
        end
    resources :offers do
      member do
        get :portrait, path: 'portrait/:portrait_id(.:format)'
      end
      resources :items
    end
  end

  namespace :myaccount do
    resources :addresses
    resources :credit_cards
    resources :orders, :only => [:index, :show]
    resource :overview, :only => [:show]
    resource :store_credit, :only => [:show]
  end

  namespace :my_studio do
    resources :clients
    resource :dashboard, :only => [:show]
    resources :infos do
      collection do
        get :samples
        get :faq
        get :mock_collection
      end
    end
    resources :minisites do
      member do
        get :show_collection
        get :show_chains
        get :show_charms
      end
    end
    resource :overview, :only => [:show]
    resources :sessions do
      get :is_finished_uploading_portraits
      resources :portraits do
        collection do
          get :upload_status_messages
        end
      end
    end
    resources :staffers
  end

  resources :order_items
  resources :orders
  resources :payment_profiles
  resources :prospects

  namespace :shopping do
    match 'edit_delivery_tracking' => 'carts#edit_delivery_tracking'
    resources :addresses
    resources :carts do
      member do
        post :update_delivery_tracking
      end
      resource :purchase
    end
    resources :items do
      member do
        post :update
      end
    end
    resources :shippings
    resources :stripe_cards
  end

  resources :states, :only => [:index]
  resources :studios, constraints: { email: /.*/ } do
    member do
      put :create_owner
      get :eap
      get :tkg
      get :new_owner
      post :send_new_account_email
      post :send_tkg_email
      get :show_branding
      get :unsubscribe, path: 'unsubscribe/:email'
    end
  end

  resources :pictures, :only => [:index, :create, :destroy]
  resources :terms, :only => [:index]
  devise_for :users, path_names: {sign_up: 'register'}
  resources :users do

  end

  match 'admin' => 'admin/overviews#index'
  match 'delivery' => 'shopping/carts#find_by_tracking'
  match 'tracking/:id', to: 'tracking#image', as: 'tracking_image'
  match 'blog' => 'blog'

end