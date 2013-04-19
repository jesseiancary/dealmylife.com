DealmylifeCom::Application.routes.draw do
  
  match "auth/:provider/callback" => "authentications#create"
  match "account/login" => "account#login", :as => :login
  match "account/logout" => "account#logout", :as => :logout
  match "account/reset_password" => "account#reset_password", :as => :reset_password
  #match "index" => "partners#show", :id => "1", :as => :index
  #match "index" => "partners#show_all", :as => :index
  match "click" => "clicks#new"
  
  resources :authentications
  
  #namespace :admintools do
    resources :users, :except => [ :show, :new_user ] do
      
      put :enable, :on => :member
      put :disable, :on => :member
      
      match "roles" => "roles#index"
      put "role" => "roles#update"
      delete "role" => "roles#destroy"
      
      match "widgets" => "widgets#list"
      put "widget" => "widgets#assign"
      delete "widget" => "widgets#remove"
      
      match "categories" => "user_categories#index"
      put "category" => "user_categories#update"
      delete "category" => "user_categories#destroy"
      
    end
  #end
  
  resources :profiles, :except => [:new, :create] do
    put :enable, :on => :member
    put :disable, :on => :member
  end
  
  namespace :profile do
    resources :addresses, :controller => "profile_addresses" do
      put :default, :on => :member
    end
  end
  

  resources :partners do
    put :enable, :on => :member
    put :disable, :on => :member
    
    #resources :categories, :controller => "partner_categories"
    resources :partner_categories, :controller => "partner_categories", :path => :categories, :as => :categories
    
  end

  #resources :partner_categories
  
=begin
  resources :attribute_groups do
    put :enable, :on => :member
    put :disable, :on => :member
  end
  
  resources :attributes do
    put :enable, :on => :member
    put :disable, :on => :member
  end
=end
  
  resources :widgets do
    put :enable, :on => :member
    put :disable, :on => :member
  end
  
  resources :pages do
    put :enable, :on => :member
    put :disable, :on => :member
  end

  resources :categories
  
  match "partners/:id/updatefile" => "partners#updatefile", :as => :updatefile
  
  match "account/edit" => "users#edit", :as => :edit_account
  match "profile/edit" => "profiles#edit", :as => :edit_profile
  match "profile" => "profiles#show", :as => :show_profile
  
  match "page/:permalink" => "pages#show_by_permalink", :as => :permalink
  
  match ":controller(/:action(/:id))"
  
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
  root :to => "partners#show_all", :as => :index

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
