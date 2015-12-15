class AddCoverImageToBooks < ActiveRecord::Migration
  def change
    add_column :books, :cover_image_uid, :string
    add_column :books, :cover_small_image_uid, :string
  end
end
