module CommentsHelper
  def content_for_deleted_comment(comment)
    case comment.deleted_by
    when "post_author"
      content_tag(:p, content_tag(:em, "Коментар було видалено автором посту"))
    when "comment_author"
      content_tag(:p, content_tag(:em, "Коментар було видалено автором"))
    when "moderator"
      content_tag(:p, content_tag(:em, "Коментар було видалено модератором"))
    end
  end
end
