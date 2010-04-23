# == Schema Information
# Schema version: 20100421160024
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

# == Schema Information
# Schema version: 20100420080406
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#
require 'digest'
class User < ActiveRecord::Base
  # Virtual attribute
  attr_accessor :password
  
  # Tell Rails which attributes of the model are accessible, i.e., which attributes can be modified by outside users (such as users submitting requests with web browsers). Using attr_accessible is important for preventing a mass assignment vulnerability, a distressingly common and often serious security hole in many Rails applications
  attr_accessible :name, :email, :password, :password_confirmation
  
  
  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    
  validates_presence_of :name, :email
  
  validates_length_of :name, :maximum => 50
  
  validates_format_of :email, :with => EmailRegex
  
  validates_uniqueness_of :email, :case_sensitive => false
  
  # Automatically create the virtual attribute 'password_confirmation'
  validates_confirmation_of :password
  
  # Password validations
  validates_presence_of :password
  validates_length_of :password, :within => 6..40
  
  
  before_save :encrypt_password
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    user && user.has_password?(submitted_password) ? user : nil
  end
  
  private
  
    def encrypt_password
      self.salt = make_salt
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
  
end
