class User < ApplicationRecord
  has_one_attached :avatar
  has_rich_text :contacts
  has_many :posts, dependent: :destroy

  has_many :sessions, dependent: :destroy

  generates_token_for :magic_link, expires_in: 15.minutes

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  normalizes :email, with: -> { it.strip.downcase }

  def empty_intro?
    posts.where(post_type: :intro).order(:id).first.nil?
  end

  def approve
    update(role: "member")
  end

  # TODO: can it be simplified?
  def newcomer?
    role == "newcomer" || member? || moderator? || admin?
  end

  def member?
    role == "member" || moderator? || admin?
  end

  def moderator?
    role == "moderator" || admin?
  end

  def admin?
    role == "admin"
  end
end
