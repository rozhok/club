class User < ApplicationRecord
  has_one_attached :avatar
  has_rich_text :contacts
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

  generates_token_for :magic_link, expires_in: 15.minutes

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  normalizes :email, with: -> { it.strip.downcase }

  def empty_intro?
    posts.where(post_type: :intro).order(:id).first.nil?
  end

  def approve
    update(role: "member")
  end

  def cast_vote(votable_id)
    votable = Comment.find(votable_id) || Post.find(votable_id)
    if votable.present? && votable.user_id != id
      votes.create(votable: votable)
      votable
    end
  end

  def retract_vote(votable_id:, votable_type:)
    vote = Vote.find_by(votable_id: votable_id, votable_type: votable_type)
    votable = vote.votable
    if vote.present?
      vote.destroy
      votable
    end
  end

  def voted_for?(votable)
    votes.exists?(votable: votable)
  end

  # TODO: can it be simplified?
  def newcomer?
    role == "newcomer"
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

  class << self
    def find_or_create_by_tg_id(tg_params)
      existing_user = User.find_by(tg_id: tg_params[:id])
      if existing_user.present?
        return existing_user
      end

      User.create(email: "#{tg_params[:id]}@#{ENV.fetch("BASE_DOMAIN")}",
                  tg_id: tg_params[:id],
                  username: tg_params[:username],
                  name: "#{tg_params[:first_name]} #{tg_params[:last_name]}",
                  role: "member")
    end
  end
end
