class AccessPolicy
  include AccessGranted::Policy

  def configure
    role :admin, proc { |user| user&.admin? } do
      can :manage, User
    end

    role :moderator, proc { |user| user&.role.in?(%w[member moderator admin]) } do
      can [:approve, :reject], Post
      can :destroy, Comment
    end

    role :member, proc { |user| user&.role.in?(%w[member moderator admin]) } do
      can :create, Intro

      can [:create, :read], Post
      can [:update, :destroy], Post do |post, user|
        post.user == user
      end

      can [:create, :read], Comment
      can :update, Comment do |comment, user|
        comment.user == user && comment.deleted_at.nil?
      end
      can :destroy, Comment do |comment, user|
        comment.user == user || comment.post.user == user
      end

      can [:create, :destroy], Vote

      can :read, User
    end

    role :newcomer, proc { |user| user&.newcomer? } do
      can :create, Intro
      can [:update, :read], Post do |post, user|
        post.user == user
      end
    end
  end
end
