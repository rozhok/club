class User < ApplicationRecord
  has_secure_password

  validates :title, presence: true, uniqueness: true, length: { minimum: 3, maximum: 25 }
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 25 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :bio, presence: true

  def generate_session_token
    token = SecureRandom.urlsafe_base64
    update_attribute(:session_token, token)
    token
  end

  def invalidate_session
    update_attribute(:session_token, nil)
  end

  class << self
    def self.find_by_session_token(token)
      find_by(session_token: token)
    end
  end
end
