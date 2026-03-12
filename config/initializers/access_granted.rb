# monkey-patch for seamless evaluation of classes vs instances in AccessGranted policy
module AccessGranted
  class Permission
    def matches_conditions?(subject)
      if @block && !subject.is_a?(Class)
        @block.call(subject, @user)
      else
        matches_hash_conditions?(subject)
      end
    end
  end
end