class Api::V1::BooksController < Api::V1::BaseController

  def create
    Book.new(books_param).save!
    render json: '', status: :created
  end

  def index
    books = Book.all.order(id: :desc)

    # if params[:rentable]
    #   books = books.rentable
    # end

    if params[:search_text]
      books = books.search_text(params[:search_text])
    end

    if params[:offset]
      books = books.offset(params[:offset])
    end

    limit = params[:limit] || 10
    books = books.limit(limit)

    books = books.eager_load(rentals: :user)
    books = books.where(rentals: {returned_date: NIL})

    render json: to_api_response(books)
    # render json: to_api_response_rented(books)
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
      }
    end

    data_rentals = Rental.all.eager_load(:user).where(returned_date:NIL).order(id: :desc)
    data_rented = data_rentals.map do |date_rental|{
      user_name:  date_rental.user.last_name + ' ' + date_rental.user.first_name ,
      rented_date: date_rental.rented_date,
      rented_book_id: date_rental.book_id,
      is_rentable: false,
      }
    end
    

    {
      count: books.limit(nil).offset(nil).count,
      data:  data,
      data_rented: data_rented,
    }
  end


  #   def to_api_response_rented(books){
  #     data_rentals = Rental.all.eager_load(:user).order(id: :desc)
  #     data_rentals.map do |date_rental|{
  #         user_name:  date_rental.user.last_name + date_rental.user.first_name ,
  #         rented_date: date_rental.rented_date,
  #       }
  #     end
  #   }
  #   {
  #     count: books.limit(nil).offset(nil).count,
  #     data:  data,
  #   }
  # end

  # def booklist
  #   # lists = Book.eager_load(:author).left_outer_joins(rentals: :user).pluck(:title,:name,:last_name,:first_name) # 表示確認のためのpluckの使用
  #   # 本の著者の名前を内部連結
  #   # 本一覧と借りている人の名前を外部連結し(返した人も現状表示されている)
  #   # lists = Book.eager_load(:author).left_outer_joins(rentals: :user).where(rentals: {returned_date: NIL}).where.not(rentals: {rented_date: NIL})
  #   lists = Book.all.order(id: :desc)
  #   lists = lists.left_outer_joins(:rentals).where(rentals: {returned_date: NIL}) #リストの外部連結&返却された本の情報削除
    
  #   if params[:search_text]
  #     lists = lists.search_text(params[:search_text])
  #   end

  #   if params[:offset]
  #     lists = lists.offset(params[:offset])
  #   end

  #   limit = params[:limit] || 10
  #   lists = lists.limit(limit)

  #   render json: to_api_response(lists)
  # end

  # def to_api_booklist(lists)
  #   data = lists.map do |list|
  #     if (lists.rented_date != NIL)
  #       puts "TRUE"
  #     else
  #       puts "FALSE"
  #     end
  #     # {
  #     #   id:          list.id,
  #     #   title:       list.title,
  #     #   author_name: list.name,
  #     # }
  #   end

end
