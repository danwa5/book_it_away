class Author < ActiveRecord::Base
  has_many :books
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :nationality, presence: true
  validate :author_dob_cannot_be_in_the_future,
           :valid_author_nationalities
  
  def author_dob_cannot_be_in_the_future
    if !self.dob.nil? && self.dob >= Date.today
      errors.add(:dob," can only be in the past")
    end
  end
  
  def valid_author_nationalities
    countries = %w[Canada France Sweden UK USA]
    errors.add(:nationality, "needs to be in permitted list") unless countries.include?(self.nationality)
  end
end
