class AddSlugToBooks < ActiveRecord::Migration
  def change
    add_column :books, :slug, :string, unique: true
  end
end
