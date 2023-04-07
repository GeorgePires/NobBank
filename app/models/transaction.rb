class Transaction < ApplicationRecord
  belongs_to :account

  validates :amount, presence: true

  scope :history_transactions, -> { order(created_at: :desc).limit(8) }
  scope :deposit, -> { where(transaction_type: "deposit").count }
  scope :withdraw, -> { where(transaction_type: "withdraw").count }
end
