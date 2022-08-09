class Api::V1::RentalsController < Api::V1::BaseController

  def create
    today = Date.current

    ActiveRecord::Base.transaction do
      rentals_params[:book_ids].each do |book_id|
        # TODO: ログインユーザのIDにする
        Rental.create!(book_id:               book_id,
                       user_id:               1,
                       rented_date:           today,
                       scheduled_return_date: today + 7.days)
      end
    end

    render json: { status: 'success' }, status: :created
  end

  def index
    rentals = Rental.renting_now
                    .where(user_id: 1) # TODO: ログインユーザのIDにする

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

  private

  def rentals_params
    # TODO: require(:rental) っている？なしでいいのでは？
    # refs: https://corycory.hateblo.jp/entry/error/param-is-missing-or-the-value-is-empty/
    # params.require(:rental).permit(
    res = params.permit(:book_ids)
    res[:book_ids] = res[:book_ids].split(',')

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
