class Book < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }

  belongs_to :author
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
    general_education:1,
    first_foreign_language: 2,
    second_foreign_language: 3,
    literature: 4,
    psychology: 5,
    jurisprudence: 6,
    economics: 7,
    business_administration: 8,
    math: 9,
    physics: 10,
    chemistry: 11,
    biology: 12,
    infomatics: 13,
    medicine: 14,
    pharmacy: 15,
    Others: 16
  }

end
