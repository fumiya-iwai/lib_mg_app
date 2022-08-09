class Api::V1::BaseController < ActionController::Base
  include Authenticate

  skip_before_action :verify_authenticity_token

  rescue_from StandardError, with: :standard_error
  rescue_from ActiveRecord::RecordInvalid, with: :validation_error

  def standard_error(error)
    render json: { status: 'error', error: error.to_s }, status: :unprocessable_entity
  end

  def validation_error(error)
    render json: { status: 'error', errors: error_message(error.record) }, status: :unprocessable_entity
  end

  private

  def error_message(record)
    record.errors.keys.map {|key| [key, record.errors.full_messages_for(key)]}.to_h
  end
end
