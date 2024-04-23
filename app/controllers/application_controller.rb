class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :invalid

  def invalid(exception)
    render json: ErrorSerializer.serialize(ErrorMessage.new(exception.message, 400)), status: 400
  end
end
