GremastersWeb::Application.routes.draw do
  
  get "progress_report/index"

  get "progress_report/show"

  get "transactions/index"

  ### API routes go here.
    
  # API v1
  namespace :api do
    namespace :v1 do
      resources :quizzes, :only => [:show], defaults: { format: :json } do
        resources :sections, :only => [:index, :show] do
  
        end
      end
  
      resources :attempts, :only => [:index, :update], defaults: { format: :json } do
  
      end
      resources :attempt_details, :only => [:create], defaults: { format: :json } do

      end
    end
  end
  #api routes.
  get "api/v1/attempt_details" => "api/v1/attempt_details#index"
  get "api/v1/attempt_details/questions_status" => "api/v1/attempt_details#get_questions_status"
  post "api/v1/attempts/update_time" => "api/v1/attempts#update_time" 
  post "api/v1/visits/create" => "api/v1/visits#create"
  post "api/v1/visits/set_end_time" => "api/v1/visits#set_end_time"  
  
  # Admin routes.
  get "admins/home"
  
  # Quiz routes.
    # Sections sub-routes
    # Questions sub-routes
    # Options sub-routes
    get "quizzes/get_current_attempt"
    resources :quizzes do
      resources :sections do
        resources :questions do
          resources :options
        end    
      end
      member do
        post 'upload_question_images'
        post 'delete_question_images'
        post 'upload_full_excel'
        post 'upload_verbal_excel'
        post 'upload_quant_excel'
        post 'publish'
        post 'unpublish'
        post 'approve'
        post 'unapprove'
        post 'reject'
      end
    end
  
    resources :section_types
  
    resources :quiz_types
  
  namespace :admins do
    # Offer routes.
    resources :offers
    resources :offer_codes
    match "offers/:id/add_quiz_to_offer" => "offers#add_quiz_to_offer", via: [:put], :as => "add_quiz_to_offer"
    match "offers/:id/add_package_to_offer" => "offers#add_package_to_offer", via: [:put], :as => "add_package_to_offer"
    match 'offers/:id/destroy_quiz_from_offer/:quiz_id', to: 'offers#destroy_quiz_from_offer', via: [:delete], as: 'destroy_quiz_from_offer'
    match 'offers/:id/destroy_package_from_offer/:package_id', to: 'offers#destroy_package_from_offer', via: [:delete], as: 'destroy_package_from_offer'
    match "offers/:id/add_emails_to_offer" => "offers#add_emails_to_offer", via: [:put], :as => "add_emails_to_offer"
    match 'offers/:id/destroy_email_from_offer/:email', to: 'offers#destroy_email_from_offer', via: [:delete], as: 'destroy_email_from_offer' , :email => /[^\/]*/
    
    # Package routes.
    resources :packages
    match "packages/:id/add_quiz_to_package" => "packages#add_quiz_to_package", via: [:put], :as => "add_quiz_to_package"
    match 'packages/:id/destroy_quiz_from_package/:quiz_id', to: 'packages#destroy_quiz_from_package', via: [:delete], as: 'destroy_quiz_from_package'
    
    # Category routes.
    resources :categories
    
    # Type routes.
    resources :types
    
    # Topic routes.
    resources :topics
  end

  resources :reports, :only=>[:index,:show] do
  end

  resources :reviews, :only=>[:show] do
  end
  
  # Store routes.
  ## Store route to show timed / practice tests. 
  match "timed_tests" => "stores#timed_tests", via: [:get], :as => "timed_tests"
  match "practice_tests" => "stores#practice_tests", via: [:get], :as => "practice_tests"
  
  ## Store route to show all tests for full/category/topic
  match "timed_tests/full_tests" => "stores#show_all_full_timed_tests", via: [:get], :as => "show_all_full_timed_tests"
  match "timed_tests/categories/:category_slug" => "stores#category_all_timed_tests", via: [:get], :as => "category_all_timed_tests"
  match "timed_tests/topics/:topic_slug" => "stores#topic_all_timed_tests", via: [:get], :as => "topic_all_timed_tests"
  match "practice_tests/categories/:category_slug" => "stores#category_all_practice_tests", via: [:get], :as => "category_all_practice_tests"
  match "practice_tests/topics/:topic_slug" => "stores#topic_all_practice_tests", via: [:get], :as => "topic_all_practice_tests"
  
  ## Store route to show detailed view for a quiz
  match "timed_tests/full_tests/:quiz_slug" => "stores#show_full_timed_test", via: [:get], :as => "show_full_timed_test"
  match "timed_tests/categories/:category_slug/:quiz_slug" => "stores#show_category_timed_test", via: [:get], :as => "show_category_timed_test"
  match "timed_tests/topics/:topic_slug/:quiz_slug" => "stores#show_topic_timed_test", via: [:get], :as => "show_topic_timed_test"
  match "practice_tests/categories/:category_slug/:quiz_slug" => "stores#show_category_practice_test", via: [:get], :as => "show_category_practice_test"
  match "practice_tests/topics/:topic_slug/:quiz_slug" => "stores#show_topic_practice_test", via: [:get], :as => "show_topic_practice_test"

  get "landings/index"

  # Root route.
  # root :to => "homes#index"
  
  # Homes controller routes.
  get "homes/index"
  match "homes/reset_user_quizzes" => "homes#reset_user_quizzes", via: [:delete], :as => "reset_user_quizzes"


  devise_for :users,  :controllers => { :registrations => "users/registrations", :confirmations => 'confirmations' } do

    #get "/", :to => "devise/sessions#new"

  end
  
  devise_scope :user do
    post "/confirm" => "confirmations#confirm"
  end
  
  get "test_center/error"
  # Users::Controllers actions
  match "users/profiles/update_profile_pic" => "users/profiles#update_profile_pic", via: [:post], :as => "update_profile_pic"
  match "users/profiles/remove_profile_pic" => "users/profiles#remove_profile_pic", via: [:delete], :as => "remove_profile_pic"
  get "test_center/index"
  match 'test_center' => 'test_center#index'
  match 'test_center/*anything' => "test_center#index"
  
  # Credits routes
  get "credits/index"
  match "credits/:user_id/new" => "credits#new", via: [:get], :as => "new_credit"
  match "credits/:user_id/create" => "credits#create", via: [:post], :as => "credits"
  match "credits/activity_log" => "credits#activity_log", via: [:get], :as => "credits_activity_log"
  match "credits/:user_id/remove_credits" => "credits#remove_credits", via: [:delete], :as => "remove_credits"

  # Cart routes.
  resources :carts, :only => [:index]

  # CartItem routes.
  resources :cart_items, :only => [:create,:destroy]
  
  # Orders routes.
  resources :orders, :only => [:index,:show]
  match "orders/:id/transactions" => "orders#transactions", via: [:get], :as => "order_transactions"
  
  # Checkout routes.
  match "stores/cart" => "checkout#show_cart", via: [:get], :as => "show_cart"
  match "buy/test/:id" => "checkout#buy_test", via: [:get], :as => "checkout_buy_test"
  match "buy/package/:id" => "checkout#buy_package", via: [:get], :as => "checkout_buy_package"
  match 'process_payment' => 'checkout#process_payment'
  match 'z_response'      => 'checkout#z_response'
  
  # Students routes.
  resources :students, :only => [:index,:new,:create]
  match '/students/upload_via_excel' => "students#upload_via_excel", via: [:post], :as => "upload_students_via_excel"

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
