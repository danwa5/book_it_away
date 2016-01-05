class Post < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title
  validates_presence_of :body

  scope :published, -> { where(status: 1).order('posted_at DESC') }

  enum status: { unpublish: 0, publish: 1 }
end