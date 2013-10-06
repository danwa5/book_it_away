class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.decimal :rating
      t.text :comments
      t.integer :likes
      t.integer :dislikes
      t.integer :book_id
      t.integer :user_id

      t.timestamps
    end
    
    add_index :reviews, [:book_id, :created_at]
    add_index :reviews, [:user_id, :created_at]
  end
end
