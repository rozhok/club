class AddTgIdToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :tg_id, :bigint, default: nil
  end
end
