GremastersWeb::Application.routes.draw do
  
  get "progress_report/index"

  get "progress_report/show"

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
    
    # QuizType routes.
    resources :quiz_types
    
    # SectionType routes.
    resources :section_types
    
    # Students routes.
    resources :students, :only => [:index,:new,:create]
    match '/students/upload_via_excel' => "students#upload_via_excel", via: [:post], :as => "upload_students_via_excel"
    match "/students/:user_id/reconfirm" => "students#reconfirm", via: [:post], :as => "reconfirm_user"
    match "/students/:user_id/delete" => "students#delete", via: [:delete], :as => "delete_user"
    match "/students/:user_id/confirm" => "students#confirm", via: [:post], :as => "confirm_user"
    
    # Transaction routes.
    resources :transactions, :only => [:index]
    
    # Credits routes.
    # Credits routes
    resources :credits, :only => [:index]
    match "credits/:user_id/new" => "credits#new", via: [:get], :as => "new_user_credit"
    match "credits/:user_id/create" => "credits#create", via: [:post], :as => "user_credits"
    match "credits/activity_log" => "credits#activity_log", via: [:get], :as => "credits_activity_log"
    match "credits/:user_id/remove_credits" => "credits#remove_credits", via: [:delete], :as => "remove_credits"
    
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
  end

  resources :reports, :only=>[:index,:show] do
  end

  resources :reviews, :only=>[:show] do
  end
  
  # Store routes.
  match 'store' => "stores#index", via: [:get], :as => "store"
  
  ## Store route to show all tests for full/category/topic
  match "store/full_tests" => "stores#show_all_full_tests", via: [:get], :as => "show_all_full_tests"
  match "store/verbal_tests" => "stores#show_all_verbal_tests", via: [:get], :as => "show_all_verbal_tests"
  match "store/quant_tests" => "stores#show_all_quant_tests", via: [:get], :as => "show_all_quant_tests"
  match "store/categories/:category_slug" => "stores#show_category_all_tests", via: [:get], :as => "show_category_all_tests"
  match "store/topics/:topic_slug" => "stores#show_topic_all_tests", via: [:get], :as => "show_topic_all_tests"
  
  ## Store route to show detailed view for a quiz
  match "store/full_tests/:quiz_slug" => "stores#show_full_test", via: [:get], :as => "show_full_test"
  match "store/verbal_tests/:quiz_slug" => "stores#show_verbal_test", via: [:get], :as => "show_verbal_test"
  match "store/quant_tests/:quiz_slug" => "stores#show_quant_test", via: [:get], :as => "show_quant_test"
  match "store/categories/:category_slug/:quiz_slug" => "stores#show_category_test", via: [:get], :as => "show_category_test"
  match "store/topics/:topic_slug/:quiz_slug" => "stores#show_topic_test", via: [:get], :as => "show_topic_test"

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
