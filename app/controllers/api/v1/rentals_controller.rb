class Api::V1::RentalsController < Api::V1::BaseController

  def create
    today = Date.current

    ActiveRecord::Base.transaction do
      rentals_params[:book_ids].each do |book_id|
        Rental.create!(book_id:               book_id,
                       user_id:               current_user.id,
                       rented_date:           today,
                       scheduled_return_date: today + 7.days)
        user = current_user
        user.point += 1
        user.save!
      end
    end

    render json: '', status: :created
    
  end

  def index
    rentals = Rental.renting_now
                    .where(user_id: current_user.id)
                    .order(rented_date: :asc, id: :asc)

    if params[:search_text]
      rentals = rentals.joins(:book).merge(Book.search_text(params[:search_text]))
    end

    if params[:offset]
      rentals = rentals.offset(params[:offset])
    end

    limit = params[:limit] || 10
    rentals = rentals.limit(limit)

    render json: to_api_response(rentals)
  end

  def return_books
    user = current_user
    rentaling_ids =[]
    rentaling_ids =return_books_params[:rental_ids]
    rentaling_ids.each do |x,i|
      date = Rental.where(user_id: current_user).where(id: x).pluck(:scheduled_return_date)
      
      if date[0] < Date.today then
        user.point -= 3
        user.save!
      end
    end
    rentals = Rental.renting_now
                    .where(id: return_books_params[:rental_ids], user_id: current_user.id)
    rentals.update_all(returned_date: Date.current)

    render json: '', status: :no_content
    user = current_user
    user.point += return_books_params[:rental_ids].size
    

    
    user.save!
    #返した数ポイント加算
    

  end

  private

  def rentals_params
    # TODO: require(:rental) っている？なしでいいのでは？
    # refs: https://corycory.hateblo.jp/entry/error/param-is-missing-or-the-value-is-empty/
    # params.require(:rental).permit(
    res = params.permit(:book_ids)
    res[:book_ids] = res[:book_ids].split(',')

    res
  end

  def return_books_params
    # TODO: require(:rental) っている？なしでいいのでは？
    res = params.permit(:rental_ids)
    res[:rental_ids] = res[:rental_ids].split(',')

    res
  end

  def to_api_response(rentals)
    data = rentals.eager_load({ book: :author }, :user).map do |rental|
      {
        id:                    rental.id,
        title:                 rental.book.title,
        author_name:           rental.book.author.name,
        user_name:             rental.user.full_name,
        rented_date:           rental.rented_date,
        scheduled_return_date: rental.scheduled_return_date,
        returned_date:         rental.returned_date,
      }
      
    end

    {
      count: rentals.limit(nil).offset(nil).count,
      data:  data,
    }
  end

end
