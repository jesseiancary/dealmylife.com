class Widget < ActiveRecord::Base
	attr_protected :enabled
	
	validates_presence_of :name
	validates_presence_of :title
	
	validates_length_of :name, :within => 3..64
	validates_length_of :title, :within => 3..64
	validates_length_of :head, :maximum => 1000
	validates_length_of :content, :maximum => 1000
	
	has_many :user_widgets
	has_many :users, :through => :user_widgets
end