class Book < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :scoped, scope: :author

  belongs_to :author
  has_many :reviews
  has_and_belongs_to_many :subjects

  attr_accessor :gbook
  
  before_save {
    self.title = book_title_case(title)
    self.publisher = publisher.titleize
  }
  
  # ***** call from controller instead *****
  # after_initialize :get_google_book_info
  
  validates :isbn, presence: true, uniqueness: true, format: { with: /[0-9]{10}/}, length: { is: 10 }
  validates :title, presence: true, length: { maximum: 100 }
  validates :publisher, allow_nil: true, length: { maximum: 50 }
  validates :pages, allow_nil: true, numericality: { greater_than_or_equal_to: 1 }
  validates :author, presence: true
  
  default_scope -> { order('title ASC') }
  
  class << self
    def title_search(query)
      where("title ilike ?", "%#{query}%")
    end

    def author_search(query)
      joins(:author).where("first_name || ' ' || last_name ILIKE ?", "%#{query}%")
    end

    def google_books_api_isbn_search(isbn)
      begin
        GoogleBooks.search('isbn:' + isbn).first
      rescue SocketError => e
        puts e.message
      end
    end
  end

  def image
    gbook.present? ? gbook.image_link : 'image_unavailable.jpg'
  end
  
  def description
    gbook.present? ? gbook.description : ''
  end
  
  def average_rating
    gbook.present? ? gbook.average_rating : 'n/a'
  end
  
  def ratings_count
    gbook.present? ? gbook.ratings_count : 0
  end
  
  def book_title_case(title)
    cap_exceptions = %w(of a the and an or nor but if then else when up at from by on off for in out over to)
    title = title.downcase.split.map {|w| cap_exceptions.include?(w) ? w : w.capitalize}.join(' ')
    title = title[0,1].capitalize + title[1, title.length-1]
  end
  
  def get_google_book_info
    if isbn.present?
      Rails.logger.info 'get_google_book_info invoked in model for ' + self.title
      begin
        self.gbook = GoogleBooks.search('isbn:' + isbn).first
      rescue SocketError => e
        puts e.message
      end
    end
  end
 
  def categorized_under?(subject)
    self.subjects.include?(subject)
  end
  
  def non_categorized_subjects
    Subject.all - self.subjects
  end
  
  def subject_string
    self.subjects.map(&:name).sort.join(', ')
  end
end
