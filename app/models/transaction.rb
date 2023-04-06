class Transaction < ApplicationRecord
  belongs_to :account

  validates :amount, presence: true

  scope :history_transactions, -> { order(created_at: :desc).limit(8) }
  scope :credit, -> { where(transaction_type: "credit").count }
  scope :debit, -> { where(transaction_type: "debit").count }
end
