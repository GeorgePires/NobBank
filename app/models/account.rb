class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :balance, presence: true
  validates :account_number, presence: true, uniqueness: true

  #before_validation :check_status

  def deposit(amount)
    if amount > 0
      ActiveRecord::Base.transaction do
        self.balance += amount
        save!
        transaction = transactions.create!(transaction_type: "deposit", amount: amount)
        transaction
      end
    else
      raise "Invalid amount"
    end
  end

  def withdraw(amount)
    if amount.positive?
      if self.balance >= amount
        ActiveRecord::Base.transaction do
          self.balance -= amount
          save!
          transaction = transactions.create!(transaction_type: "withdraw", amount: amount)
          transaction
        end
      else
        raise "Insufficient funds"
      end
    else
      raise "Invalid amount"
    end
  end

  def transfer(amount, account)
    if self.balance >= amount && self.id != account.id
      ActiveRecord::Base.transaction do
        total_amount = calc_transfer_fee(amount)
        if self.balance >= total_amount
          update(balance: self.balance -= total_amount) 
          account.update(balance: account.balance += amount)
          transaction = transactions.create!(destiny_account: account.account_number, transaction_type: "transfer", amount: amount)
          transaction
        else
          raise "Insufficient funds"
        end
      end
    else
      raise "Insufficient funds"
    end
  end

  private

  def calc_transfer_fee(amount)
    total_amount = 0
    if ([0, 6].exclude?(Time.current.wday) && (Time.now.hour >= 9 && Time.now.hour < 18))
      total_amount = amount + 5
    else
      total_amount = amount + 7
    end
    total_amount += 10 if amount > 1000
    total_amount
  end

  #def check_status
  #  unless self.status
  #    raise "Invalid account status"
  #  end
  #end
end
