class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account_and_user, only: %i[ credit create_credit debit create_debit transactions transfer create_transfer]

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
    @account = Account.find(params[:id])
    @transactions = Transaction.where(account_id: @account.id).history_transactions
  end

  def destroy
    @account = Account.find(params[:id])
    @account.update(status: false)
    redirect_to accounts_path
  end

  def credit; end
  def debit; end
  def transfer; end

  def create_credit
    amount = params[:amount].to_f
    begin
      if @account.credit(amount)
        redirect_to accounts_path, notice: "Credit of $ #{amount} was successful."
      end
    rescue StandardError => e
      redirect_to accounts_path, alert: "Credit of $ #{amount} was unsuccessful: #{e.message}"
    end
  end

  def create_debit
    amount = params[:amount].to_d
    begin
      if @account.debit(amount)
        redirect_to accounts_path, notice: "Debit of $ #{amount} was successful."
      end
    rescue StandardError => e
      redirect_to accounts_path, alert: "Debit of $ #{amount} was unsuccessful: #{e.message}"
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

  def transactions
    @transactions = @account.transactions.order(created_at: :desc)
  end

  private

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
