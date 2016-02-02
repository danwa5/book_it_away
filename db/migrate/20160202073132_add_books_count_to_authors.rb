class AddBooksCountToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :books_count, :integer, default: 0
  end
end
