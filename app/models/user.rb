require 'digest'

class User < ActiveRecord::Base
  # added :password and :password_confirmation to avoid mass-assign protected attributes error
  attr_accessible :email, :password, :password_confirmation
  
  attr_accessor :password
  validates :email,   :uniqueness => true,
                      :length => { :within => 5..50 },
                      :format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i }
  validates :password, :confirmation => true,
            :length => { :within => 4..20 },
            :presence => true,
            :if => :password_required?

  has_one :userinfo

  has_many :lists, :order => 'name'

  before_save :encrypt_new_password
  
  def self.authenticate(email, password)
    user = find_by_email(email)
    return user if user && user.authenticated?(password)
  end
  
  def authenticated?(password)
    self.hashed_password == encrypt(password)
  end
  
  protected
    def encrypt_new_password
      return if password.blank?
      self.hashed_password = encrypt(password)
    end
    
    def password_required?
      hashed_password.blank? || password.present?
    end
    
    def encrypt(string)
      Digest::SHA1.hexdigest(string)
    end                              
end
