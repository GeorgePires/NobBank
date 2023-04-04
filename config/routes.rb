Rails.application.routes.draw do
  get 'transactions/index'
  get 'transactions/show'

  get 'welcome/index'
  
  devise_for :users
  root 'welcome#index'
  resources :accounts
end
