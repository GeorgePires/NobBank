# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :account

  validates :amount, presence: true

  scope :order_transactions, -> { order(created_at: :desc) }
  scope :deposit, -> { where(transaction_type: 'deposit').count }
  scope :withdraw, -> { where(transaction_type: 'withdraw').count }
end
