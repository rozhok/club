class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy, inverse_of: :post
  has_rich_text :content

  validates :title, presence: true
  validates :content, presence: true

  def replies
    post_comments = comments.includes(user: { avatar_attachment: :blob }).order(:id).with_rich_text_content_and_embeds
    parent_to_children = {}
    post_comments.each do |comment|
      if comment.parent_id.present?
        parent_to_children[comment.parent_id] ||= []
        parent_to_children[comment.parent_id] << comment
      end
    end

    sorted_comments = []
    post_comments.each do |comment|
      if comment.parent_id.nil?
        sorted_comments << comment
        add_children(comment, parent_to_children, sorted_comments)
      end
    end
    sorted_comments
  end

  def add_children(comment, parent_to_children, result)
    child_comments = parent_to_children[comment.id]
    if child_comments.present?
      child_comments.each do |child|
        result << child
        add_children(child, parent_to_children, result)
      end
    end
  end

  def comments_count_text
    if comments_count.zero?
      "Немає коментарів"
    elsif comments_count == 1
      "1 коментар"
    elsif comments_count <= 4
      "#{comments_count} коментарі"
    else
      "#{comments_count} коментарів"
    end
  end
end
