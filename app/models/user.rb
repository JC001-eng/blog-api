class User < ApplicationRecord
  has_secure_password
  has_many :posts, dependent: :destroy
  validates :username, presence: true, uniqueness: true

  def generate_password_reset
    token = SecureRandom.urlsafe_base64
    update!(
      reset_password_token: Digest::SHA256.hexdigest(token),
      reset_password_sent_at: Time.current
    )
    token
  end

  def valid_password_reset_token?(token)
    return false if reset_password_sent_at < 2.hours.ago

    Digest::SHA256.hexdigest(token) == reset_password_token
  end
end
