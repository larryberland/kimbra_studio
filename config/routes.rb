KimbraStudio::Application.routes.draw do

  namespace :minisite do resources :showrooms end

  namespace :minisite do
    resources :showrooms do
      get :show, :path => 'customer/:id/studio/:id(.:format)'
    end
  end

  namespace :admin do  namespace :customer do resources :item_sides end end

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
    resources :mini_sites
    resources :sessions do
      resources :portraits do
        resources :faces
      end
    end
    resources :clients
    resources :staffers
  end

end
