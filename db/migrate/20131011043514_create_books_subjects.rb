class CreateBooksSubjects < ActiveRecord::Migration
  def change
    create_table :books_subjects, :id => false do |t|
      t.integer :book_id, :null => false
      t.integer :subject_id, :null => false
    end
    
    add_index :books_subjects, [:book_id, :subject_id], :unique => true
  end
end
