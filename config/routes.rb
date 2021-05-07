Rails.application.routes.draw do
  mount StripeEvent::Engine, at: '/__stripe_webhooks__'
  devise_for :users, :controllers => {:registrations => "user/registrations"}
  root to: 'pages#home'
  get 'terms-and-conditions' => 'pages#terms', as: 'terms'
  get 'privacy-policy' => 'pages#privacy', as: 'privacy'
  get "plans" => "subscriptions#plans", as: :plans
  resources :subscriptions do
    collection do
      get :plan_update
      get :subscribe
      get :cancel_subscription
      get :resubscribe
      get :sign_out_free_user
    end
  end
  namespace :admin do
    root to: 'pages#dashboard'
    resources :products, except: :destroy do
      get :autocomplete_product_company_name, on: :collection
      resources :documents, only: [:new, :create]

      # collection do
      #   get :pending_approval
      # end
      member do
        put  :approve_product
        get  :product_remarks
        post :remarks_create
      end
      get :countries, on: :collection
    end
    resources :documents, only: [:edit,:update,:show, :destroy]
    resources :companies do
      member do
        put :archive
        put :unarchive
      end
      collection do
        get :edit_card
        post :update_card
      end
    end
    resources :users do
      member do
        put :archive
        put :unarchive
        put :approve
        put :reject
      end
    end
    resources :enquiries, only: [:index, :show]
  end
  resources :companies, only: [:show]
  resources :products, only: [:show] do
    get :search, on: :collection
    post :get_products_count , on: :collection
    post :seller_popup , on: :collection
    get :sellect_contact
  end
  resources :pages,only:[:basic_search] do
    get :basic_search , on: :collection
    get :cookie_policy , on: :collection
  end
  get 'contact', :to => 'enquiries#new'
  post 'contact', :to => 'enquiries#create'
  get 'contact/thanks', :to => 'enquiries#thanks'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
