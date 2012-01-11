KimbraStudio::Application.routes.draw do

  namespace :studio do resources :pictures end

  namespace :studio do resources :clients end

  resources :studios

  resources :pictures

  devise_for :users

  resources :users

  match 'admin' => 'admin/overviews#index'
  match 'login' => 'user_sessions#new'
  match 'logout' => 'user_sessions#destroy'
  match 'signup' => 'studio/registrations#new'

  root :to => "welcome#index"

  resources :countries

  resources :states, :only => [:index]
  resource :about, :only => [:show]
  resources :terms, :only => [:index]

  resources :categories

  resources :pieces

  resources :offers

  namespace :studio do
    resources :registrations,   :only => [:new, :create]
    resources :addresses
    resources :users
    resources :shoots
    resource  :overview, :only => [:show]
  end

end
