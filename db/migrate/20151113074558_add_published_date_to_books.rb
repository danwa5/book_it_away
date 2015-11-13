class AddPublishedDateToBooks < ActiveRecord::Migration
  def change
    add_column :books, :published_date, :date
  end
end
