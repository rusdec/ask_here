class AddNameToAttachements < ActiveRecord::Migration[5.1]
  def change
    add_column :attachements, :name, :string, default: ''
  end
end
