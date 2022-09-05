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
    categories = []
    Book.category_ids_i18n.each do |en, ja|
      categories << { value: en, label: ja }
    end
    render json: categories
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
