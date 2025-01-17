module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request!
  end

  private

  def authenticate_request
    toke = request.headers['Authorization']&.split(' ')&.last

    if token.present?
      begin
        decoded = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
        @current_user = User.find(decoded.first['user_id'])
      rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { error: 'Token is missing' }, status: :unauthorized
    end
  end
  def current_user
    @current_user
  end
end