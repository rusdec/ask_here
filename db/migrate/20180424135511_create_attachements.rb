class CreateAttachements < ActiveRecord::Migration[5.1]
  def change
    create_table :attachements do |t|
      t.string :file
      t.integer :attachable_id
      t.string :attachable_type

      t.timestamps
    end

    add_index :attachements, [:attachable_id, :attachable_type]
  end
end
