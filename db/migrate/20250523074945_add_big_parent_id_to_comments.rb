class AddBigParentIdToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :big_parent_id, :integer
    add_index :comments, :big_parent_id
  end
end
