class User < ApplicationRecord
  has_one_attached :avatar
  has_rich_text :contacts

  has_many :sessions, dependent: :destroy

  generates_token_for :magic_link, expires_in: 15.minutes

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  normalizes :email, with: -> { it.strip.downcase }

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
