class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :body
      t.integer :commentable_id
      t.integer :user_id
      t.string :commentable_type

      t.timestamps
    end
  end
end
