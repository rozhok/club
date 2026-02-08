class CreateVotes < ActiveRecord::Migration[8.1]
  def change
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :votable, polymorphic: true, null: false

      t.timestamps
    end

    add_index :votes, [:user_id, :votable_type, :votable_id], unique: true, name: "index_votes_on_user_and_votable"

    add_column :posts, :votes_count, :integer, default: 0, null: false
    add_column :comments, :votes_count, :integer, default: 0, null: false
  end
end
