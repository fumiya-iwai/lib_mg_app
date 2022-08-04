require 'csv'

BOOK_CSV_PATH = 'db/book.csv'.freeze

CSV.foreach(BOOK_CSV_PATH) do |row|
  title = row[0]
  author_name = row[1]

  author = Author.find_or_create_by!(name: author_name)
  Book.create!(title: title, author: author)
end
