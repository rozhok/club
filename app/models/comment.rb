class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  belongs_to :parent, class_name: "Comment", optional: true, inverse_of: :comments
  has_many :comments, foreign_key: :parent_id, dependent: :destroy, inverse_of: :parent
  has_many :votes, as: :votable, dependent: :destroy

  has_rich_text :content

  def padding
    case level
    when 1
      ""
    when 2
      "ml-4"
    when 3
      "ml-8"
    else
      "ml-12"
    end
  end
end
