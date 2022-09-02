class Api::V1::BooksController < Api::V1::BaseController

  def create
    Book.new(books_param).save!
    render json: '', status: :created
  end

  def index
    books = Book.all.order(id: :desc)

    if params[:rentable]
      books = books.rentable
    end

    if params[:search_text]
      books = books.search_text(params[:search_text])
    end

    if params[:offset]
      books = books.offset(params[:offset])
    end

    limit = params[:limit] || 10
    books = books.limit(limit)
    
    render json: to_api_response(books)
  end

  def categories
    categories_name_en_to_int = Book.category_ids
    categories_name_en_to_ja = Book.category_ids_i18n
    categories_name_ja_to_int = []
    categories_name_en_to_int.each do |en, int|
      value = int
      label = categories_name_en_to_ja[en]
      categories_name_ja_to_int << { value: value, label: label}
    end

    render json: categories_name_ja_to_int
  end

  private

  def books_param
    params.require(:book).permit(
      :title,
      :author_id,
      :category_id
    )
  end

  def to_api_response(books)
    data = books.eager_load(:author).map do |book|
      {
        id:          book.id,
        title:       book.title,
        author_name: book.author.name,
      }
    end

    {
      count: books.limit(nil).offset(nil).count,
      data:  data
    }
  end

end
