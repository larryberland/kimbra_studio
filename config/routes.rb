KimbraStudio::Application.routes.draw do

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
        resources :offers
      end
    end
    namespace :merchandise do
      resources :pieces
    end
  end

  namespace :my_studio do
    resource :overview, :only => [:show]
    resources :infos
    resources :mini_sites
    resources :sessions do
      resources :portraits
    end
    resources :clients
    resources :staffers
  end

end
