class Author < ActiveRecord::Base
  has_many :books
  
  before_save { 
    self.last_name = self.last_name.titleize
    self.first_name = self.first_name.titleize
  }
  
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :first_name, presence: true, length: { maximum: 50 }
  #validates :nationality, presence: true
  validate :author_dob_cannot_be_in_the_future
  
  def author_dob_cannot_be_in_the_future
    if !self.dob.nil? && self.dob >= Date.today
      errors.add(:dob," can only be in the past")
    end
  end
  
  #def valid_author_nationalities
  #  countries = %w[Canada France Sweden UK USA]
  #  errors.add(:nationality, "needs to be in permitted list") unless countries.include?(self.nationality)
  #end
  
  def name
    first_name + " " + last_name
  end
  
  def formatted_dob
    dob.nil? ? "" : dob.to_formatted_s(:long)
  end
end
