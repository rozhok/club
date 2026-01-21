class AddStateToPost < ActiveRecord::Migration[8.1]
  def change
    create_enum :post_state, ["draft", "pending", "approved", "rejected"]
    add_column :posts, :state, :enum, default: "draft", null: false, enum_type: "post_state"
  end
end
