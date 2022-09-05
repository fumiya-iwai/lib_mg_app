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
