class Book < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }

  belongs_to :author
  has_many :rentals, dependent: :destroy

  scope :rentable, -> {
    book_ids = Rental.renting_now.pluck(:book_id)
    where.not(id: book_ids)
  }

  scope :search_text, -> (text)  {
    joins(:author).where('"books"."title" like ?', "%#{text}%").or(self.where('"authors"."name" like ?', "%#{text}%"))
  }
end
