class Book < ActiveRecord::Base
  belongs_to :author
  default_scope -> { order('title ASC') }
  validates :isbn, presence: true, length: { maximum: 10 }
  validates :title, presence: true, length: { maximum: 100 }
  validates :publisher, allow_nil: true, length: { maximum: 50 }
  validates :total_pages, allow_nil: true, numericality: { greater_than_or_equal_to: 1 }
  validates :author_id, presence: true
end
