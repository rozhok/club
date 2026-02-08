class AddIsPublicToPost < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :is_public, :boolean, default: false
  end
end
