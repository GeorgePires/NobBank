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
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
