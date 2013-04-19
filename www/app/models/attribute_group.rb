class AttributeGroup < ActiveRecord::Base
	attr_accessible :enabled
	
	validates_presence_of :name
	
	validates_length_of :name, :within => 3..64
	
	has_many :attributes	# This breaks things, but seems like it should be correct
	#has_one :attribute
	
end
