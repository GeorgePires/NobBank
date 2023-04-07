class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: %i[show destroy]
  before_action :set_account_and_user, only: %i[ deposit create_deposit withdraw create_withdraw transfer create_transfer ]

  def index
    @accounts = current_user.accounts
    @total_accounts_balance = current_user.accounts.sum(:balance)
    @transactions = Transaction.all
  end

  def new
    @account = current_user.accounts.build
  end

  def create
    @account = current_user.accounts.build(account_params)
    if @account.save
      redirect_to accounts_path, notice: "Account was successfully created."
    else
      render :new
    end
  end

  def show
    @transactions = Transaction.where(account_id: @account.id).history_transactions
  end

  def destroy
    if @account.status == false
      @account.update(status: true)
      redirect_to accounts_path, notice: "Account was successfully active"
    else
      @account.update(status: false)
      redirect_to accounts_path, alert: "Account was successfully suspended"
    end
  end

  def deposit; end
  def withdraw; end
  def transfer; end

  def create_deposit
    amount = params[:amount].to_f
    begin
      if @account.deposit(amount)
        redirect_to accounts_path, notice: "Deposit of $ #{amount} was successful."
      end
    rescue StandardError => e
      redirect_to accounts_path, alert: "Deposit of $ #{amount} was unsuccessful: #{e.message}"
    end
  end

  def create_withdraw
    amount = params[:amount].to_d
    begin
      if @account.withdraw(amount)
        redirect_to accounts_path, notice: "Withdraw of $ #{amount} was successful."
      end
    rescue StandardError => e
      redirect_to accounts_path, alert: "Withdraw of $ #{amount} was unsuccessful: #{e.message}"
    end
  end

  def create_transfer
    amount = params[:amount].to_d
    account = Account.find_by(account_number: params[:account_number])
    if account.present?
      begin
        if @account.transfer(amount, account)
          redirect_to accounts_path, notice: "Transfer of $ #{amount} to #{account.account_number} was successful."
        end
      rescue StandardError => e
        redirect_to accounts_path, alert: "Transfer to #{account.account_number}: #{e.message}"
      end
    else
      redirect_to accounts_path, alert: "Account not found"
    end
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def set_account_and_user
    @user = current_user
    @account = @user.accounts.find(params[:account_id])
  end

  def account_params
    params.require(:account).permit(:balance, :status).merge(account_number: generate_account_number)
  end

  def generate_account_number
    account_number = SecureRandom.uuid[0..7].upcase
    return account_number unless Account.exists?(account_number: account_number)
  end
end
