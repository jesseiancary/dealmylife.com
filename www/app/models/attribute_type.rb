class AttributeType < ActiveRecord::Base
	attr_protected :enabled
	
	validates_presence_of :name
	
	validates_length_of :name, :within => 3..64
	
	has_one :attribute
	
end
