class Author < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  attr_accessor :authors_array

  has_many :books

  accepts_nested_attributes_for :books
  
  after_initialize {
    if new_record? && authors_array.present?
      full_name = authors_array.first
      self.first_name = full_name.partition(' ').first
      self.last_name = full_name.partition(' ').last
    end
  }

  before_save { 
    self.last_name = last_name.strip.titleize_lastname
    self.first_name = first_name.strip.titleize
  }
  
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates_uniqueness_of :first_name, scope: :last_name
  validate :valid_author_dob

  default_scope { order('last_name asc') }
  
  def valid_author_dob
    if dob.present? && dob >= Date.today
      errors.add(:dob," can only be in the past")
    end
  end
  
  def name
    first_name + ' ' + last_name
  end

  def nationality_name
    return '' if nationality.blank?
    country = ISO3166::Country[nationality]
    country.translations[I18n.locale.to_s] || country.name
  end
  
  def formatted_dob
    dob.present? ? dob.to_formatted_s(:long) : ''
  end

  def slug_candidates
    [
      [:first_name, :last_name]
    ]
  end
end
