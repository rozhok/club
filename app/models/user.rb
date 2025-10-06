class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar
  has_rich_text :contacts

  generates_token_for :password_reset, expires_in: 20.minutes do
    password_salt.last(10)
  end

  has_many :sessions, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: 8 }

  normalizes :email, with: -> { it.strip.downcase }

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  def newcomer?
    role == "newcomer"
  end

  def member?
    role == "member"
  end

  def moderator?
    role == "moderator"
  end

  def admin?
    role == "admin"
  end
end
