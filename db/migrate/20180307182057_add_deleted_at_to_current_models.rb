class AddDeletedAtToCurrentModels < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :deleted_at, :timestamp
    add_column :customers, :deleted_at, :timestamp
  end
end
