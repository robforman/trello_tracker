class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :member_id, null: false
      t.string :username, null: false
      t.string :full_name, null: false
      t.string :url, null: false
      t.string :oauth_token, null: false
      t.string :oauth_token_secret, null: false

      t.timestamps null: false
    end

    add_index :users, :member_id, unique: true
  end
end
