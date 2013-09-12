class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :last_name
      t.string :first_name
      t.date :dob
      t.string :nationality

      t.timestamps
    end
    
    add_index :authors, [:last_name, :first_name], unique: true
  end
end
