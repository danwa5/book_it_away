class Author < ActiveRecord::Base
  has_many :books
  
  before_save { 
    self.last_name = last_name.titleize
    self.first_name = first_name.titleize
  }
  
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :nationality, presence: true
  validate :valid_author_nationalities, :valid_author_dob
  
  def valid_author_dob
    if dob.present? && dob >= Date.today
      errors.add(:dob," can only be in the past")
    end
  end
  
  def valid_author_nationalities
    countries = %w[Australia Brazil Canada Germany France Spain Sweden UK USA]
    errors.add(:nationality, "needs to be in permitted list") unless countries.include?(self.nationality)
  end
  
  def name
    first_name + ' ' + last_name
  end
  
  def formatted_dob
    dob.present? ? dob.to_formatted_s(:long) : ''
  end
end
