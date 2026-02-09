class AccessPolicy
  include AccessGranted::Policy

  def configure
    # Example policy for AccessGranted.
    # For more details check the README at
    #
    # https://github.com/chaps-io/access-granted/blob/master/README.md
    #
    # Roles inherit from less important roles, so:
    # - :admin has permissions defined in :member, :guest and himself
    # - :member has permissions from :guest and himself
    # - :guest has only its own permissions since it's the first role.
    #
    # The most important role should be at the top.
    # In this case an administrator.
    #
    role :admin, proc { |user| user&.admin? } do
      can :destroy, User
    end

    role :moderator, proc { |user| user&.moderator? } do
      can :approve, Post
      can :reject, Post
      can :destroy, Comment
    end

    role :member, proc { |user| user&.member? } do
      can :read, Post
      can :create, Post
      can :create, Comment
      can :read, Comment
      can [:update, :destroy], Post do |post, user|
        post.user == user
      end
      can :update, Comment do |comment, user|
        comment.user == user && comment.deleted_at.nil?
      end
      can :destroy, Comment do |comment, user|
        comment.user == user || comment.post.user == user
      end
      can :create, Intro
      can [:create, :destroy], Vote
    end

    role :newcomer, proc { |user| user&.newcomer? } do
      can :create, Intro
      can [:update, :read], Post do |post, user|
        post.user == user
      end
    end
  end
end
