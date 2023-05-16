# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :balance, presence: true
  validates :account_number, presence: true, uniqueness: true

  # before_validation :check_status

  def deposit(amount)
    raise 'Invalid amount' unless amount.positive?

    ActiveRecord::Base.transaction do
      self.balance += amount
      save!
      transaction = transactions.create!(transaction_type: 'deposit', amount:)
      transaction
    end
  end

  def withdraw(amount)
    raise 'Invalid amount' unless amount.positive?
    raise 'Insufficient funds' unless self.balance >= amount

    ActiveRecord::Base.transaction do
      self.balance -= amount
      save!
      transaction = transactions.create!(transaction_type: 'withdraw', amount:)
      transaction
    end
  end

  def transfer(amount, account)
    raise 'Insufficient funds' unless self.balance >= amount && id != account.id

    ActiveRecord::Base.transaction do
      total_amount = calc_transfer_fee(amount)
      raise 'Insufficient funds' unless self.balance >= total_amount

      update(balance: self.balance -= total_amount)
      account.update(balance: account.balance += amount)
      transaction = transactions.create!(destiny_account: account.account_number, transaction_type: 'transfer',
                                         amount:)
      transaction
    end
  end

  private

  def calc_transfer_fee(amount)
    total_amount = if [0, 6].exclude?(Time.current.wday) && (Time.zone.now.hour >= 9 && Time.zone.now.hour < 18)
                     amount + 5
                   else
                     amount + 7
                   end
    total_amount += 10 if amount > 1000
    total_amount
  end

  # def check_status
  #  unless self.status
  #    raise "Invalid account status"
  #  end
  # end
end
