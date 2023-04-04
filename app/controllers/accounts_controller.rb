class AccountsController < ApplicationController
  layout 'welcome'
  before_action :authenticate_user!
  before_action :set_user, only: [:new, :create]
  

  def index
    @accounts = current_user.accounts
  end
  

  def new
    @account = @user.accounts.build
  end

  def create
    @account = @user.accounts.build(account_params)
    if @account.save
      redirect_to root_path, notice: "Account was successfully created."
    else
      render :new
    end
  end

  private

  def set_user
    @user = current_user
  end

  def account_params
    params.require(:account).permit(:balance, :status).merge(account_number: generate_account_number)
  end

  def generate_account_number
    account_number = SecureRandom.uuid[0..7].upcase
    return account_number unless Account.exists?(account_number: account_number)
  end
end
