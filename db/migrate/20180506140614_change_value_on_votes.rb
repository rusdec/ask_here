class ChangeValueOnVotes < ActiveRecord::Migration[5.1]
  def change
    change_column :votes, :value, 'integer USING CAST(value AS integer)', null: false
  end
end
