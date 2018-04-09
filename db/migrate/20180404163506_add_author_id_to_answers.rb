class AddAuthorIdToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :author_id, :integer
    add_index :answers, :author_id
  end
end
