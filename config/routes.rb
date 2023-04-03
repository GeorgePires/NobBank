Rails.application.routes.draw do
  get 'transactions/index'
  get 'transactions/show'
  get 'accounts/index'
  get 'accounts/new'
  get 'accounts/create'
  get 'accounts/edit'
  get 'accounts/update'
  get 'accounts/show'
  get 'welcome/index'
  
  devise_for :users
  root 'welcome#index'
end
