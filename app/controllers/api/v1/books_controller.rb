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
    
    if params[:categories]
      categories = Book.category_ids_i18n.to_a  #この_i18nを抜くとエラーが無くなるが、英語表示になってしまう。
    end

    render json: to_api_response(books,categories)
  end

  private

  def books_param
    params.require(:book).permit(
      :title,
      :author_id,
      :category_id
    )
  end

  def to_api_response(books,categories)
    data = books.eager_load(:author).map do |book|
      {
        id:          book.id,
        title:       book.title,
        author_name: book.author.name,
      }
    end

    {
      count: books.limit(nil).offset(nil).count,
      data:  data,
      categories: categories
    }
  end

end
