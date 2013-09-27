class RenameTotalPages < ActiveRecord::Migration
  def change
    rename_column :books, :total_pages, :pages
  end
end
