class Api::V1::BooksController < Api::V1::BaseController
  def create
    Book.new(books_param).save!
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

    if params[:offset]
      books = books.offset(params[:offset])
    end

    limit = params[:limit] || 10
    books = books.limit(limit)

    render json: to_api_response(books)
  end

  private

  def books_param
    params.require(:book).permit(
      :title,
      :author_id
    )
  end

  def to_api_response(books)
    data = books.eager_load(:author).map do |book|
      {
        id:          book.id,
        title:       book.title,
        author_name: book.author.name,
        is_rentable: "true",#動作確認用
      }
    end

    {
      count: books.limit(nil).offset(nil).count,
      data:  data,
    }
  end
  
  def to_boolean(bool)
    bool.downcase == "true"
  end

end
