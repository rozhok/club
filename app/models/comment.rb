class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  belongs_to :parent, class_name: "Comment", optional: true, inverse_of: :comments
  has_many :comments, foreign_key: :parent_id, dependent: :destroy, inverse_of: :parent

  has_rich_text :content
end
