# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :balance, presence: true
  validates :account_number, presence: true, uniqueness: true

  # enum status: {}

  validates :status, acceptance: { message: 'Invalid account' }, unless: :will_save_change_to_status?

  def deposit(amount)
    amount_positive?(amount)

    ActiveRecord::Base.transaction do
      self.balance += amount
      save!
      transaction = transactions.create!(transaction_type: 'deposit', amount:)
      transaction
    end
  end

  def withdraw(amount)
    amount_positive?(amount) || validate_amount(amount)

    ActiveRecord::Base.transaction do
      self.balance -= amount
      save!
      transaction = transactions.create!(transaction_type: 'withdraw', amount:)
      transaction
    end
  end

  def transfer(amount, destiny_account)
    amount_positive?(amount) || validate_amount(amount) || validate_account_id(destiny_account)
    ActiveRecord::Base.transaction do
      total_amount = calc_transfer_fee(amount)
      raise 'Insufficient funds' unless self.balance >= total_amount

      update!(balance: self.balance -= total_amount)
      destiny_account.update!(balance: destiny_account.balance += amount)
      Transaction.create!(transaction_type: 'transfer received', amount:, account_id: destiny_account.id)
      transaction = transactions.create!(destiny_account: destiny_account.account_number,
                                         transaction_type: 'transferred', amount:)
      transaction
    end
  end

  private

  def amount_positive?(amount)
    raise 'Invalid amount' unless amount.positive?
  end

  def validate_amount(amount)
    raise 'Insufficient funds' unless self.balance >= amount
  end

  def validate_account_id(destiny_account)
    raise 'Destination account must be different from source account' unless id != destiny_account.id
  end

  def calc_transfer_fee(amount)
    total_amount = if [0, 6].exclude?(Time.current.wday) && (Time.zone.now.hour >= 9 && Time.zone.now.hour < 18)
                     amount + 5
                   else
                     amount + 7
                   end
    total_amount += 10 if amount > 1000
    total_amount
  end
end
