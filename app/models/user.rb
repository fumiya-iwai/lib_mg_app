class User < ApplicationRecord
  has_secure_password

  has_many :rentals

  def full_name
    "#{self.last_name.presence} #{self.first_name.presence}".strip
  end
end
