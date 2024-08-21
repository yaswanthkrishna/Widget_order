class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Skip CSRF verification for local development
  skip_before_action :verify_authenticity_token, if: -> { Rails.env.development? }

  # Allow CORS for local development
  before_action :allow_cross_origin_requests, if: -> { Rails.env.development? }

  private

  def allow_cross_origin_requests
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end
  def not_found
    render json: { error: 'Not Found' }, status: :not_found
  end
end
