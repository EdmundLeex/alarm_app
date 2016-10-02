class AddFiedsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :facebook_id, :string, unique: true
    add_column :users, :facebook_access_token, :string, unique: true

    add_index :users, :facebook_id
    add_index :users, :facebook_access_token
  end
end
