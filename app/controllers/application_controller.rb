class ApplicationController < ActionController::API
  rescue_from AbstractController::ActionNotFound, StandardError, with: :handle_error
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  def not_found_method
    render json: { error: "routes not found" }, status: :not_found
  end

  def current_user
    @current_user ||= User.find_by(id: params[:user_id])
  end

  private
  def handle_error(exception)
    render json: Response.new(status: :bad_request, message: "fail", errors: exception), status: :internal_server_error
  end

  def handle_record_not_found(exception)
    render json: Response.new(status: :not_found, message: "fail", errors: exception), status: :not_found
  end
end
