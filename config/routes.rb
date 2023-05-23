Rails.application.routes.draw do
  # mount Rswag::Ui::Engine => '/api-docs'
  # mount Rswag::Api::Engine => '/api-docs'
  devise_for :users

  resources :accounts do
    get '/deposit', action: 'deposit'
    post '/create_deposit', action: 'create_deposit'
      
    get '/withdraw', action: 'withdraw'
    post '/create_withdraw', action: 'create_withdraw'

    get '/transfer', action: 'transfer'
    post '/create_transfer', action: 'create_transfer'
  end

  resources :transactions

  root "welcome#index"
  get 'about', to: 'welcome#about'

  # namespace :api do
  #   namespace :v1 do
  #     resources :accounts, only: [:index]
  #      #get '/users/transactions/:id', to: 'users#transactions', as: :transactions

  #      #get '/users/current_balance/:id', to: 'users#current_balance', as: :current_balance
  #      post 'accounts/deposit', to: 'accounts#deposit', as: :deposit
  #      post 'accounts/withdraw', to: 'accounts#withdraw'
  #   end
  # end
end