# config/routes.rb
Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get 'users/sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session_get
  end
  get 'orders/search', to: 'orders#search', as: 'search_orders'
  post 'orders/search_results', to: 'orders#search_results', as: 'search_results_orders'
  get 'orders/history', to: 'orders#history', as: 'order_history'  # New route for order history
  resources :orders, only: [:new, :create, :show, :edit, :update, :destroy, :index]
  root to: 'orders#new'

  # Catch-all route for missing assets
  get '*path', to: 'application#not_found', constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  }
end
