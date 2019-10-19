class AddTagsToCustomers < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :tags, :string
  end
end
