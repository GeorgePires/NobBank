# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, @transactions = pagy(current_user.account.transactions.order_transactions)
  end
end
