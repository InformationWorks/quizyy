GremastersWeb::Application.routes.draw do

  # Package routes.
  resources :packages do
    member do
       match 'destroy_quiz_from_package/:quiz_id', to: 'packages#destroy_quiz_from_package', via: [:delete], as: 'destroy_quiz_from'
    end
  end
  match "packages/:id/add_quiz_to_package" => "packages#add_quiz_to_package", via: [:put], :as => "add_quiz_to_package"
  
  # Store routes.
  get "stores/full_quizzes"
  get "stores/category_quizzes"
  match "stores/add_package_to_user/:package_id" => "stores#add_package_to_user", via: [:put], :as => "add_package_to_user"
  match "stores/add_quiz_to_user/:quiz_id" => "stores#add_quiz_to_user", via: [:post], :as => "add_quiz_to_user"

  # Quiz routes.
  # Sections sub-routes
  # Questions sub-routes
  # Options sub-routes
  resources :quizzes do
    member do
       post 'upload_full_excel'
    end
    resources :sections do
      resources :questions do
        resources :options
      end    
    end
  end

  resources :section_types

  resources :quiz_types

  resources :types

  resources :topics

  resources :categories

  get "landings/index"

  # Root route.
  # root :to => "homes#index"
  
  # Homes controller routes.
  get "homes/index"
  match "homes/reset_user_quizzes" => "homes#reset_user_quizzes", via: [:delete], :as => "reset_user_quizzes"


  devise_for :users,  :controllers => { :registrations => "users/registrations" } do

    #get "/", :to => "devise/sessions#new"

  end
  
  # Users::Controllers actions
  match "users/profiles/update_profile_pic" => "users/profiles#update_profile_pic", via: [:post], :as => "update_profile_pic"
  match "users/profiles/remove_profile_pic" => "users/profiles#remove_profile_pic", via: [:delete], :as => "remove_profile_pic"

  get "test_center/index"
  match 'test_center' => 'test_center#index'
  match 'test_center/*anything' => "test_center#index"

  root :to => "landings#index"
  # Devise routes.
  # devise_scope :user do
  #  pending for custom URL ike localhost:3000/sign_in
  # end
  
  #root :to => "homes/index"
  
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
