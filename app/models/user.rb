class User < ApplicationRecord
  has_secure_password

  has_many :rental

  def full_name
    "#{self.last_name.presence} #{self.first_name.presence}".strip
  end
end
