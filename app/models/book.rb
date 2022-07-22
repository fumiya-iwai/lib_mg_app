class Book < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }

  belongs_to :author
  has_many :rental
end
