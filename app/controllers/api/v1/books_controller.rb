class Api::V1::BooksController < Api::V1::BaseController

  def create
    ActiveRecord::Base.transaction do
      Book.new(books_param).save!
      user = current_user
      user.point += 10
      user.save!
    end
    render json: '', status: :created
  end

  def index
    books = Book.all.order(id: :desc)

    if to_boolean(params[:rentable])
      books = books.rentable
    end

    if params[:search_text]
      books = books.search_text(params[:search_text])
    end

    if params[:search_category]
      books = books.where(category_id: params[:search_category])
    end

    if params[:offset]
      books = books.offset(params[:offset])
    end

    limit = params[:limit] || 10
    books = books.limit(limit)
    
    render json: to_api_response(books)
  end

  def categories
    categories = []
    Book.category_ids_i18n.each do |en, ja|
      categories << { value: en, label: ja }
    end
    render json: categories
  end

  private

  def to_boolean(bool)
    bool.downcase == "true"
  end

  def books_param
    params.require(:book).permit(
      :title,
      :author_id,
      :category_id
    )
  end

  def to_api_response(books)
    data = books.eager_load(:author).includes(rentals: :user).references(rentals: :user).map do |book|
      is_rentable = (book.rentals.size > 0 ? false : true)
      user_name = ''
      
      if is_rentable == false
        rental = book.rentals[0]
        user_name = rental.user.last_name + ' ' + rental.user.first_name
      end

      {
        id:          book.id,
        title:       book.title,
        category_name: book.category_id_i18n,
        author_name: book.author.name,
        is_rentable: is_rentable,
        rental_state: is_rentable ? '貸出可能' : '貸出不可',
        rental_user_name: user_name
      }
    end

    {
      count: books.limit(nil).offset(nil).count,
      data:  data
    }
  end
end
