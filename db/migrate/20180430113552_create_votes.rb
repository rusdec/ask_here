class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.integer :votable_id
      t.string :votable_type
      t.integer :user_id
      t.boolean :value

      t.timestamps
    end

    add_index :votes, [:votable_id, :user_id, :votable_type], unique: true
  end
end
