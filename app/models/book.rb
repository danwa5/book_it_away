class Book < ActiveRecord::Base
  belongs_to :author
  
  attr_accessor :gbook
  
  before_save { 
    self.title = book_title_case(self.title)
    self.publisher = self.publisher.titleize
  }
  
  after_initialize :get_google_book_info #, :except => [:index, :new]
  
  validates :isbn, presence: true, length: { maximum: 10 }
  validates :title, presence: true, length: { maximum: 100 }
  validates :publisher, allow_nil: true, length: { maximum: 50 }
  validates :pages, allow_nil: true, numericality: { greater_than_or_equal_to: 1 }
  validates :author_id, presence: true
  
  validates_format_of :isbn, with: /[0-9]{10}/
  
  default_scope -> { order('title ASC') }
  
  def image
    self.gbook.nil? ? "" : self.gbook.image_link
  end
  
  def average_rating
    self.gbook.nil? ? "" : self.gbook.average_rating
  end
  
  def ratings_count
    self.gbook.nil? ? "" : self.gbook.ratings_count
  end
  
  def book_title_case(title)
    cap_exceptions = [ 
      'of','a','the','and','an','or','nor','but','if','then','else','when',
      'up','at','from','by','on', 'off','for','in','out','over','to'
    ]
    title = title.downcase.split.map {|w| cap_exceptions.include?(w) ? w : w.capitalize}.join(" ")
    title = title[0,1].capitalize + title[1, title.length-1]
  end
  
  private
  
    def get_google_book_info
      Rails.logger.info "get_google_book_info called"
      if !self.isbn.nil?
        self.gbook = GoogleBooks.search('isbn:' + isbn).first
      end
    end
 
  #def upfirst
  #  self[0,1].capitalize + self[1,length-1]
  #end
  
  #def titleize_name
  #  self.title = self.title.titleize
  #end
end
