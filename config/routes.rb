Rails.application.routes.draw do
  devise_for :users
  
  resources :accounts do
    get '/credit', action: 'credit'
    post '/create_credit', action: 'create_credit'
      
    get '/debit', action: 'debit'
    post '/create_debit', action: 'create_debit'

    get '/transfer', action: 'transfer'
    post '/create_transfer', action: 'create_transfer'

    get '/transactions', action: 'transactions'
  end
  
  resources :transactions, only: [:edit, :update, :show]

  root "welcome#index"
end
