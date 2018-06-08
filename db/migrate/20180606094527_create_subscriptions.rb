class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.integer :user_id, null: false
      t.integer :subscribable_id, null: false
      t.string :subscribable_type, null: false
      t.timestamps
    end

    add_index :subscriptions, [:user_id, :subscribable_id, :subscribable_type],
      unique: true, name: 'uniqueness_subscription'
  end
end
