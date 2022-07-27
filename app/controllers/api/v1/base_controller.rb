class Api::V1::BaseController < ActionController::Base
  skip_before_action :verify_authenticity_token

  rescue_from StandardError, with: :error422

  def error422(error)
    render json: { status: 'error', error: error.to_s }, status: :unprocessable_entity
  end
end
