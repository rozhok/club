class AddDeletedAtToPostsAndComments < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :deleted_at, :datetime
    add_column :posts, :deleted_by, :string
    add_column :comments, :deleted_at, :datetime
    add_column :comments, :deleted_by, :string
  end
end
