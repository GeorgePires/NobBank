Rails.application.routes.draw do
  devise_for :users
  
  resources :accounts do
    get '/deposit', action: 'deposit'
    post '/create_deposit', action: 'create_deposit'
      
    get '/withdraw', action: 'withdraw'
    post '/create_withdraw', action: 'create_withdraw'

    get '/transfer', action: 'transfer'
    post '/create_transfer', action: 'create_transfer'
  end
  
  resources :transactions, only: [:edit, :update, :show]

  root "welcome#index"
end
