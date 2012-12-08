class CreateFacebookUsers < ActiveRecord::Migration
  def change
    create_table :facebook_users do |t|
      t.string :provider
      t.string :uid
      t.string :email
      t.string :name
      t.string :image_url
      t.string :oauth_token
      t.datetime :oauth_expires_at

      t.timestamps
    end
  end
end
