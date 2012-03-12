KimbraStudio::Application.routes.draw do

  resources :order_items

  resources :orders

  namespace :minisite do
    resources :showrooms do
      member do
        get :collection
      end
    end
  end

  resources :image_layouts

  resources :studios

  devise_for :users, :path_names => {:sign_up => 'register'}
  resources :users

  match 'admin' => 'admin/overviews#index'
  #match 'login' => 'user_sessions#new'
  #match 'logout' => 'user_sessions#destroy'
                        #match 'signup' => 'my_studio/registrations#new'

  root :to => "welcome#index"

  resource :about, :only => [:show]
  resources :terms, :only => [:index]

  resources :countries
  resources :states, :only => [:index]

  resources :categories # studio session categories

  namespace :admin do
    resource :overview, :only => [:show]
    namespace :customer do
      resources :emails do
        member do
          post :generate
          get  :session_list
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
  end

  namespace :my_studio do
    resource :overview, :only => [:show]
    resource :dashboard, :only => [:show]
    resources :infos
    resources :minisites
    resources :sessions do
      resources :portraits do
        resources :faces
      end
    end
    resources :clients
    resources :staffers
  end

  resources :payment_profiles

  namespace :myaccount do
    resources :orders, :only => [:index, :show]
    resources :addresses
    resources :credit_cards
    resource  :store_credit, :only => [:show]
    resource  :overview, :only => [:show]
  end

end