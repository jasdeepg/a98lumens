A98lumens::Application.routes.draw do
  devise_for :users

  ActiveAdmin.routes(self)

  root :to => "static_pages#home"

  match 'sandbox', :to=> "users#sandbox", :as => "sandbox"
  match 'about', :to=> "static_pages#about", :as => "about"
  match 'contact', :to=> "static_pages#contact", :as => "contact"
  match 'projects', :to=> "static_pages#projects", :as => "projects"
  match 'get/state_retail_price', :to => "static_pages#state_retail_price", :as => "state_retail_price"
  match 'test', :to=> "static_pages#test", :as => "test"
  match 'learn', :to=> "static_pages#learn", :as => "learn"
  match 'faqs', :to=> "static_pages#faqs", :as => "faqs"
  match 'consult', :to=> "static_pages#consult", :as => "consult"
  match 'pricing', :to=> "static_pages#pricing", :as => "pricing"
  match 'reserve', :to=> "static_pages#reserve", :as => "reserve"
  match 'benefits', :to=> "static_pages#benefits", :as => "benefits"
  match 'submit_reserve', :to=> "static_pages#submit_reserve", :as => "submit_reserve"
  match 'info_mail', :to=> "static_pages#info_mail", :as => "info_mail"
  match 'calculator', :to=> "static_pages#calculator", :as => "calculator"
  match 'data/state_retail_price', :to => "static_pages#state_retail_price", :as => "state_retail_price"

  resources :energy_data

  resources :users

  match '/users/edit', :to => "devise/registrations#edit", :as => "edit_user_registration"
  match '/users/new', :to => "devise/registrations#new", :as => "new_user_registration"
  match 'get/user_data', :to => "users#user_inst_data", :as => "user_inst_data"


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
