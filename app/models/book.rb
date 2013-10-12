class Book < ActiveRecord::Base
  belongs_to :author
  has_many :reviews
  has_and_belongs_to_many :subjects
  
  attr_accessor :gbook
  
  before_save { 
    self.title = book_title_case(self.title)
    self.publisher = self.publisher.titleize
  }
  
  # ***** call from controller instead *****
  # after_initialize :get_google_book_info
  
  validates :isbn, presence: true, length: { maximum: 10 }
  validates :title, presence: true, length: { maximum: 100 }
  validates :publisher, allow_nil: true, length: { maximum: 50 }
  validates :pages, allow_nil: true, numericality: { greater_than_or_equal_to: 1 }
  validates :author_id, presence: true
  
  validates_format_of :isbn, with: /[0-9]{10}/
  
  default_scope -> { order('title ASC') }
  
  def image
    self.gbook.nil? ? "image_unavailable.jpg" : self.gbook.image_link
  end
  
  def average_rating
    self.gbook.nil? ? "n/a" : self.gbook.average_rating
  end
  
  def ratings_count
    self.gbook.nil? ? "0" : self.gbook.ratings_count
  end
  
  def book_title_case(title)
    cap_exceptions = [ 
      'of','a','the','and','an','or','nor','but','if','then','else','when',
      'up','at','from','by','on', 'off','for','in','out','over','to'
    ]
    title = title.downcase.split.map {|w| cap_exceptions.include?(w) ? w : w.capitalize}.join(" ")
    title = title[0,1].capitalize + title[1, title.length-1]
  end
  
  def get_google_book_info(user_ip)
    if !self.isbn.nil?
      Rails.logger.info "get_google_book_info invoked in model for " + self.title
      self.gbook = GoogleBooks.search('isbn:' + self.isbn, {}, user_ip).first
    end
  end
 
  def self.title_search(query)
    if Rails.env.production?
      where("title ilike ?", "%#{query}%")
    else
      where("title like ?", "%#{query}%")
    end
  end
  
  def self.author_search(query)
    if Rails.env.production?
      find_by_sql ["select b.* from books b, authors a where a.id = b.author_id and a.first_name || ' ' || a.last_name ilike ? limit 6", "%#{query}%"]
    else
      find_by_sql ["select b.* from books b, authors a where a.id = b.author_id and a.first_name || ' ' || a.last_name like ? limit 6", "%#{query}%"]
    end
  end
  
  def categorized_under?(subject)
    self.subjects.include?(subject)
  end
  
  def non_categorized_subjects
    Subjects.find(:all) - self.subjects
  end
  
  def get_subjects
    str = String.new
    unless self.subjects.blank?
      #self.subjects.each do |s|
      #  str << "b"
      #end
    end
  end

end
