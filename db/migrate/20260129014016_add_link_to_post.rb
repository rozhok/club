class AddLinkToPost < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :link, :string, default: ""
  end
end
