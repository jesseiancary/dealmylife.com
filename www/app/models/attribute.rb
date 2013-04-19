class Attribute < ActiveRecord::Base
	attr_protected :enabled
	
	validates_presence_of :name
	validates_presence_of :attribute_type_id
	validates_presence_of :attribute_group_id
	
	validates_length_of :name, :within => 3..64
	
	validates_numericality_of :length, :only_integer => true
	
	belongs_to :attribute_type
	belongs_to :attribute_group
	
end
