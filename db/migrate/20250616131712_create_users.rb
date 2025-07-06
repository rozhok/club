class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.string :username, index: { unique: true }
      t.string :name
      t.string :title
      t.string :company
      t.string :location
      t.string :role

      t.timestamps
    end
  end
end
