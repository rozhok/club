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
    role :admin, proc { |user| user.admin? } do
      can :destroy, User
    end

    # More privileged role, applies to registered users.
    #
    role :member, proc { |user| user.member? } do
      can :read, Post
      can :create, Post
      can :create, Comment
      can :read, Comment
      can :update, Post do |post, user|
        post.user == user
      end
      can :destroy, Post do |post, user|
        post.user == user
      end
      can :update, Comment do |comment, user|
        comment.user == user
      end
    end

    role :newcomer, proc { |user| user.newcomer? } do
      can :create, Intro
      can [:update, :read], Post do |post, user|
        post.user == user
      end
    end

    # The base role with no additional conditions.
    # Applies to every user.
    #
    # role :guest do
    #  can :read, Post
    #  can :read, Comment
    # end
  end
end
