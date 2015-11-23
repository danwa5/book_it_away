class Category < ActiveRecord::Base
  has_and_belongs_to_many :books

  default_scope { order('name asc') }

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  before_validation {
    self.name = name.strip if name.present?
  }
  before_save {
    self.name = name.titleize if name.present?
  }
end
