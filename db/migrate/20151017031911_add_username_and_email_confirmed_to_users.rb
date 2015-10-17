class AddUsernameAndEmailConfirmedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, unique: true, null: false
    add_column :users, :email_confirmed, :boolean, default: false
    add_column :users, :confirm_token, :string

    add_index :users, :username, unique: true
  end
end
