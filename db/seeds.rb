require 'csv'

BOOK_CSV_PATH = 'db/book.csv'.freeze

CSV.foreach(BOOK_CSV_PATH) do |row|
  title = row[0]
  author_name = row[1]
  category_id = row[2].to_i

  author = Author.find_or_create_by!(name: author_name)
  Book.create!(title: title, author: author, category_id: category_id)
end

User.create!(last_name: '和田', first_name: '哲也', email: 'wada@example.com', password: 'ingage', password_confirmation: 'ingage',point:0)
User.create!(last_name: '永田', first_name: '兆', email: 'nagata@example.com', password: 'ingage', password_confirmation: 'ingage',point:0)

Rental.create!(book_id: 20, user_id: 1, rented_date: Date.new(2022, 8, 20), scheduled_return_date: Date.new(2022, 8, 27))
Rental.create!(book_id: 19, user_id: 1, rented_date: Date.new(2022, 8, 2), scheduled_return_date: Date.new(2022, 8, 9))
Rental.create!(book_id: 18, user_id: 1, rented_date: Date.new(2022, 6, 10), scheduled_return_date: Date.new(2022, 6, 17))
Rental.create!(book_id: 17, user_id: 2, rented_date: Date.new(2022, 9, 2), scheduled_return_date: Date.new(2022, 9, 7))
Rental.create!(book_id: 16, user_id: 2, rented_date: Date.new(2022, 9, 2), scheduled_return_date: Date.new(2022, 9, 7))
Rental.create!(book_id: 15, user_id: 2, rented_date: Date.new(2022, 9, 2), scheduled_return_date: Date.new(2022, 9, 7))