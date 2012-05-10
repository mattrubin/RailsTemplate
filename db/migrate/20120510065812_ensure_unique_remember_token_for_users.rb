class EnsureUniqueRememberTokenForUsers < ActiveRecord::Migration
  def up
    remove_index  :users, :remember_token
    add_index  :users, :remember_token, unique: true
  end

  def down
    remove_index  :users, :remember_token
    add_index  :users, :remember_token
  end
end
