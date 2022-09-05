class Book < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }

  belongs_to :author
  belongs_to :category
  has_many :rentals, dependent: :destroy
  has_many :users, through: :rentals

  scope :rentable, -> {
    book_ids = Rental.renting_now.pluck(:book_id)
    where.not(id: book_ids)
  }

  scope :search_text, -> (text)  {
    joins(:author).where('"books"."title" like ?', "%#{text}%").or(self.where('"authors"."name" like ?', "%#{text}%"))
  }

  enum category_id: {
    English: 1,
    Math: 2,
    Physics: 3,
    Science: 4,
    Biology: 5,
    Others: 6,
  }

end
