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

  private

  def rentals_params
    # TODO: require(:rental) っている？なしでいいのでは？
    # refs: https://corycory.hateblo.jp/entry/error/param-is-missing-or-the-value-is-empty/
    # params.require(:rental).permit(
    res = params.permit(:book_ids)
    res[:book_ids] = res[:book_ids].split(',')

    res
  end

end
