KimbraStudio::Application.routes.draw do

  match 'auth/:provider/callback', to: 'facebook_sessions#create'
  match 'auth/failure', to: 'facebook_sessions#failure'
  match 'facebook_signout', to: 'facebook_sessions#destroy', as: 'facebook_signout'

  root :to => "welcome#index"

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
      resources :friends
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

  resources :facebook_sessions, only: [:create, :destroy] do
    member do
      post :like
      post :failure
    end
  end

  resources :image_layouts

  namespace :minisite do
    resources :emails do
      collection do
        get :kill_session
      end
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
          get :index_custom
          get :index_friends, path: 'friend_id/:friend'
        end
      end
      resources :friends
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

  namespace :my_studio do
    resources :clients
    resource :dashboard, :only => [:show]
    resources :infos do
      collection do
        get :samples
        get :faq
        get :mock_collection
        get :mock_collection_return
      end
    end
    resources :minisites do
      member do
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

  resources :prospects

  namespace :shopping do
    resources :addresses
    resources :carts do
      new do
        post :edit_delivery_tracking
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
  resources :studios, constraints: {email: /.*/} do
    collection do
      get :emails
      post :send_studio_email_campaign
    end
    member do
      put :create_owner
      get :eap # TODO obsolete
      get :tkg # TODO obsolete
      get :xms # TODO obsolete
      get :new_owner
      post :send_new_account_email # TODO obsolete
      post :send_studio_email
      get :show_branding
      get :unsubscribe, path: 'unsubscribe/:email'
    end
  end

  resources :terms, :only => [:index]
  devise_for :users, path_names: {sign_up: 'register'}
  resources :users do

  end

  match 'admin' => 'admin/overviews#index'

  # sets up the Find edit/update shopping/carts actions
  match 'delivery' => 'shopping/carts#find_by_tracking'

  match 'tracking/:id', to: 'tracking#image', as: 'tracking_image'
  match 'blog' => 'blog'

  if Rails.env.development?
    mount MailPreview => 'mail_view'
  end

end