class Post < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title
  validates_presence_of :body

  scope :published, -> { where(status: 1).order('posted_at DESC') }

  scope :posted_within, ->(yyyymm) { where("date_part('month', posted_at) = ? and date_part('year', posted_at) = ?", yyyymm[4..5].to_i, yyyymm[0..3].to_i) if yyyymm.present? }

  scope :month_and_published_count, -> { where(status: 1).
                          select("select to_char(posted_at, 'YYYY') || to_char(posted_at, 'MM')").
                          group("to_char(posted_at, 'YYYY') || to_char(posted_at, 'MM')").
                          order("to_char(posted_at, 'YYYY') || to_char(posted_at, 'MM') DESC").
                          count(:id) }

  enum status: { unpublish: 0, publish: 1 }
end