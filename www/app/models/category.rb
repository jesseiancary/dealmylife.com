class Category < ActiveRecord::Base
  validates_presence_of :name
  
  has_many :user_categories
  has_many :users, :through => :user_categories
  
  has_many :partner_categories
  has_many :partners, :through => :partner_categories
  
end
