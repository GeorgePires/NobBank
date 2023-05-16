# frozen_string_literal: true

class User < ApplicationRecord
  has_many :accounts, dependent: :destroy

  after_create :create_account

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true
  validates :first_name, length: { minimum: 3 }

  def full_name
    "#{first_name} #{last_name}"
  end

  def create_account
    account_number = (Digest::SHA1.hexdigest(SecureRandom.uuid)[0..7]).upcase
    return if Account.exists?(account_number:)

    Account.create!(user_id: id, balance: 0.00, account_number:, status: true)
  end
end
