class Api::V1::AuthorsController < Api::V1::BaseController

  def create
    Author.new(authors_param).save!
    render json: { status: 'success' }, status: :created
  end

  private

  def authors_param
    params.require(:author).permit(
      :name
    )
  end

end
