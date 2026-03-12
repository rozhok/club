class AddIsPublicToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :is_public, :boolean, default: false
  end
end
