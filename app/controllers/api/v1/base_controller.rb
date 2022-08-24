class Api::V1::BaseController < ActionController::Base
  include Authenticate

  # CSRF トークンチェックをスキップ
  skip_before_action :verify_authenticity_token

  rescue_from StandardError, with: :standard_error
  rescue_from ActiveRecord::RecordInvalid, with: :validation_error

  def standard_error
    render json: { error: 'サーバーエラーが発生しました。' }, status: :internal_server_error
  end

  def validation_error(error)
    render json: { error: error.record.errors.full_messages }, status: :bad_request
  end
end
