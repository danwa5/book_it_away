class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :isbn
      t.string :title
      t.string :publisher
      t.integer :total_pages
      t.integer :author_id

      t.timestamps
    end
    
    add_index :books, :isbn, unique: true
  end
end
