class SetLikesDislikesDefaultValue < ActiveRecord::Migration
  def change
    change_column :reviews, :likes, :integer, {default: 0}
    change_column :reviews, :dislikes, :integer, {default: 0}
  end
end
