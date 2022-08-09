class Api::V1::BooksController < Api::V1::BaseController

  def create
    Book.new(books_param).save!
    render json: { status: 'success' }, status: :created
  end

  private

  def books_param
    params.require(:book).permit(
      :title,
      :author_id
    )
  end

end
