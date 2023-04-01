class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :first_name, :last_name, presence: true
  validates :first_name, length: { minimum: 3 }

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
