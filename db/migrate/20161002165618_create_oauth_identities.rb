class CreateOauthIdentities < ActiveRecord::Migration
  def change
    create_table :oauth_identities do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :access_token
      t.references :user, index: true, foreign_key: true
    end

    add_index :oauth_identities, [:provider, :uid], unique: true
  end
end
