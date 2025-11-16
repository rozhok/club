class AddTypeToPost < ActiveRecord::Migration[8.1]
  def change
    create_enum :post_type, ["intro", "post", "link", "project", "question", "guide"]
    add_column :posts, :post_type, :enum, default: "post", null: false, enum_type: "post_type"
  end
end
