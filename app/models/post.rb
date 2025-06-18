class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy, inverse_of: :post
  has_rich_text :content
end
