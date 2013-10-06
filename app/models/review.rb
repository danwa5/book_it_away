class Review < ActiveRecord::Base
  belongs_to :book
  belongs_to :user
  
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :comments, presence: true
  validates :book_id, presence: true
  validates :user_id, presence: true
  
  default_scope -> { order('created_at DESC') }
end
