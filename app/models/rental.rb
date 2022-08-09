class Rental < ApplicationRecord

  belongs_to :book
  belongs_to :user

  validate :check_renting_now, on: :create

  scope :renting_now, -> {
    where(returned_date: nil)
  }

  def check_renting_now
    if Rental.renting_now.exists?(book_id: self.book_id)
      errors.add(:base, '現在貸し出し中の本のため、貸し出せません。')
    end
  end
end
