class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.string :email, unique: true, null: false

      t.timestamps
    end
  end
end
