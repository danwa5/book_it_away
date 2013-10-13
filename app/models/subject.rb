class Subject < ActiveRecord::Base
  has_and_belongs_to_many :books
  
  before_validation {
    self.name = self.name.strip
  }
  
  before_save {
    self.name = self.name.titleize
  }
  
  validates :name, presence: true, uniqueness: { case_sensitive: false } 
end
