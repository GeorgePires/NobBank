# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account_with_user

  def index
    @account = current_user.account
    @transactions = current_user.account.transactions.order_transactions.limit(8)
  end

  def destroy
    if @account.status?
      @account.update!(status: false)
      redirect_to accounts_path, alert: 'Account was successfully suspended'
    else
      @account.update!(status: true)
      redirect_to accounts_path, notice: 'Account was successfully active'
    end
  end

  # GET
  def deposit; end
  def withdraw; end
  def transfer; end

  def create_deposit
    amount = params[:amount].to_f
    begin
      redirect_to accounts_path, notice: "Deposit of $ #{amount} was successful." if @account.deposit(amount)
    rescue StandardError => e
      redirect_to accounts_path, alert: "Deposit of $ #{amount} was unsuccessful: #{e.message}"
    end
  end

  def create_withdraw
    amount = params[:amount].to_d
    begin
      redirect_to accounts_path, notice: "Withdraw of $ #{amount} was successful." if @account.withdraw(amount)
    rescue StandardError => e
      redirect_to accounts_path, alert: "Withdraw of $ #{amount} was unsuccessful: #{e.message}"
    end
  end

  def create_transfer
    amount = params[:amount].to_d
    destiny_account = Account.find_by(account_number: params[:account_number])

    if destiny_account.present? && destiny_account.status?
      begin
        if @account.transfer(amount, destiny_account)
          redirect_to accounts_path,
          notice: "Transfer of $ #{amount} to #{destiny_account.account_number} was successful."
        end
      rescue StandardError => e
        redirect_to accounts_path, alert: "Transfer to #{destiny_account.account_number}: #{e.message}"
      end
    else
      redirect_to accounts_path, alert: 'Account not found'
    end
  end

  private

  def set_account_with_user
    @account = current_user.account
  end

  def account_params
    params.require(:account).permit(:balance, :status, :account_number)
  end
end
