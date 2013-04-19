require 'digest/sha2'
require 'securerandom'

class User < ActiveRecord::Base
  
	attr_protected :hashed_password, :enabled
	attr_accessor :password, :remember_me

	validates_presence_of :email
	validates_presence_of :password, :if => :password_required?
	validates_presence_of :password_confirmation, :if => :password_required?

	validates_confirmation_of :password, :if => :password_required?
	
	validates_uniqueness_of :email, :case_sensitive => false
	
	validates_length_of :email, :within => 5..128
	validates_length_of :password, :within => 6..20, :if => :password_required?
	
	has_many  :authentications, :dependent => :destroy
	
	has_many	:user_roles, :dependent => :destroy
	has_many	:roles, :through => :user_roles
	
	has_many	:user_widgets, :dependent => :destroy
	has_many	:widgets, :through => :user_widgets
  
  has_many  :user_categories, :dependent => :destroy
  has_many  :categories, :through => :user_categories
	
	has_one		:profile, :dependent => :destroy
	
	has_many  :clicks
	
	#acts_as_mappable
	
	before_save :hash_password
	def hash_password
		self.hashed_password = User.encrypt(password) if !password.blank?
	end

	def password_required?
		(hashed_password.blank? && authentications.empty?) || !password.blank?
	end
	
	def reset_password
    random_string = SecureRandom.hex(8)
    self.hashed_password = User.encrypt random_string
    self.save
    return random_string
  end

	def self.encrypt(string)
		return Digest::SHA256.hexdigest(string)
	end
	
	def self.authenticate(email, password)
		find_by_email_and_hashed_password_and_enabled(email, User.encrypt(password), true)
	end
	
	def has_role?(rolename)
		self.roles.find_by_name(rolename) ? true : false
	end
	
	def has_widget?(widgetname)
		self.widgets.find_by_name(widgetname) ? true : false
	end
  
  def has_category?(categoryid)
    self.categories.find_by_id(categoryid) ? true : false
  end
  
end