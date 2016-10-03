class AddOauthFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :oauth_token, :string

    add_index :users, :oauth_token, unique: true
  end
end
