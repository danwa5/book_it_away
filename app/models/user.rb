class User < ActiveRecord::Base
  has_many :reviews

  before_save { self.email = email.downcase }
  before_create :create_remember_token, :create_confirm_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :last_name, presence: true, length: { maximum: 50 }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :username, presence: true, length: { maximum: 20 }, uniqueness: { case_sensitive: false }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, length: { minimum: 6 }

  class << self
    def new_secure_token
      SecureRandom.urlsafe_base64
    end

    def encrypt(token)
      Digest::SHA1.hexdigest(token.to_s)
    end
  end
  
  def name
    first_name + ' ' + last_name
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_secure_token)
    end

    def create_confirm_token
      self.confirm_token = User.new_secure_token if self.confirm_token.blank?
    end
end
