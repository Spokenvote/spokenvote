Spokenvote::Application.routes.draw do

  root :to => 'application#index'

  ActiveAdmin.routes(self)

  devise_for :users, path_names: { sign_in: "login", sign_out: "logout" },
                     controllers: { omniauth_callbacks: "omniauth_callbacks", :sessions => 'sessions', :registrations => "registrations", :authentications => "authentications" }

  devise_scope :user do
    post 'authentications', to: 'authentications#create'
  end

  resources :users, only: [:show] do
    resources :proposals, only: [:index]
  end

  resources :proposals do
    member do
      get :is_editable
      get :related_vote_in_tree
      get :related_proposals
    end
  end

  resources :votes, only: [:create]

  resources :hubs, only: [:create, :index, :show] do
    resources :proposals
  end

  get 'currentuser' => 'users#currentuser'

  require 'robots_generator' # Rails 3 does not autoload files in lib
  get '/robots.txt' => RobotsGenerator

  get 'voter_mailer/vote_notification'

  get '/*page' => 'application#index'
  get ':controller(/:action(/:id))(.:format)' => redirect('/')

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  # Keep in mind you can assign values other than :controller and :action

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
end
