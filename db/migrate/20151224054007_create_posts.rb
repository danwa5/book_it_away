class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.string     :title, null: false
      t.text       :body, null: false
      t.integer    :status, default: 0
      t.string     :photo_uid
      t.datetime   :posted_at

      t.timestamps null: false
    end
  end
end
