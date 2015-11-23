class Book < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :scoped, scope: :author

  belongs_to :author
  has_many :reviews
  has_and_belongs_to_many :categories

  accepts_nested_attributes_for :categories

  attr_accessor :gbook
  
  before_save {
    self.title = book_title_case(title)
    self.publisher = publisher.to_s.strip.titleize
  }

  validates :isbn, presence: true, uniqueness: true, format: { with: /[0-9]{10}/}, length: { is: 10 }
  validates :title, presence: true, length: { maximum: 100 }
  validates :publisher, allow_nil: true, length: { maximum: 50 }
  validates :pages, numericality: { greater_than_or_equal_to: 1, allow_blank: true }
  validates :author, presence: true
  
  default_scope -> { order('title ASC') }

  scope :last_added, -> { unscope(:order).order('created_at DESC').limit(4) }
  
  class << self
    def title_search(query)
      where("title ilike ?", "%#{query}%")
    end

    def author_search(query)
      joins(:author).where("first_name || ' ' || last_name ILIKE ?", "%#{query}%")
    end
  end

  def load_google_books_data
    self.gbook = GoogleBooksService.call(isbn) if self.isbn.present?
  end

  def publisher
    self[:publisher].present? ? self[:publisher] : gbook.try(:publisher).to_s
  end

  def pages
    self[:pages].present? ? self[:pages] : gbook.try(:page_count).to_s
  end

  def image
    gbook.present? ? gbook.try(:image_link).to_s : 'image_unavailable.jpg'
  end
  
  def description
    self[:description].present? ? self[:description] : gbook.try(:description).to_s
  end
  
  def average_rating
    gbook.present? ? gbook.try(:average_rating) : 'N/A'
  end
  
  def ratings_count
    gbook.present? ? gbook.try(:ratings_count) : 0
  end
  
  def book_title_case(title)
    cap_exceptions = %w(of a the and an or nor but if then else when up at from by on off for in out over to)
    title = title.downcase.split.map { |w| cap_exceptions.include?(w) ? w : w.capitalize }.join(' ')
    title = title[0,1].capitalize + title[1, title.length-1]
  end

  def categorized_under?(category)
    self.categories.include?(category)
  end
  
  def excluded_categories
    Category.all - self.categories
  end
  
  def category_string
    self.categories.map(&:name).sort.join(', ')
  end

  def add_categories(category_ids)
    unless category_ids.empty?
      category_ids.each do |category_id|
        category = Category.find(category_id)
        if excluded_categories.include?(category)
          self.categories << category
        end
      end
    end
  end

  def remove_categories(categories_to_remove)
    unless categories_to_remove.blank?
      self.categories.delete(categories_to_remove)
    end
  end
end
