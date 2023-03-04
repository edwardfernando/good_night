class ApplicationController < ActionController::API
  rescue_from AbstractController::ActionNotFound, StandardError, with: :handle_error
  def not_found_method
    render json: { error: "routes not found" }, status: :not_found
  end

  private
  def handle_error(exception)
    render json: { error: exception }, status: :internal_server_error
  end
end
