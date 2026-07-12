class AddAdminAndPasswordResetTokenToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :admin, :boolean, default: false, null: false
    add_column :users, :password_reset_token, :string
    add_index :users, :password_reset_token
  end
end
