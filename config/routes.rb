MagicHat::Application.routes.draw do
  root :to => 'pages#home'
  resources :users, except: :index
  resources :sessions, :only => [:new, :create, :destroy]
  resources :groups do
    resources :invitations do
      member do
        get :accept
        post :resend
        delete :destroy
      end
    end
  end

  match 'group/:id/remove_member/:user_id' => 'groups#remove_member', :via => 'DELETE', :as => 'remove_group_member'
  match 'invitations' => 'invitations#list_invitations_addressed_to_me', :via => 'GET', :as => 'list_invitations_addressed_to_me'
  resources :goals, :except => :index


  resources :tasks, :except => :index do
    member do
      put :complete_toggle
    end
    collection do
      put :complete
    end
  end

  get "sessions/new"

  match '/signup', :to => 'users#new'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/dashboard', :to => 'dashboard#index'
  match '/dashboard/edit', :to => 'dashboard#edit', :as => "edit"
end
