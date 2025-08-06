class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotSaved, with: :not_found

  private

  def not_found
    render json: { circle: "Resource not found" }, status: :not_found
  end
end
