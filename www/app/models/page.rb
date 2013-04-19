class Page < ActiveRecord::Base
	attr_protected :enabled
	
	validates_presence_of :name, :title
	validates_length_of :name, :within => 3..64
	validates_length_of :title, :within => 3..64
	validates_length_of :content, :maximum => 15000
	
	before_create :create_permalink
	def create_permalink
		@attributes["permalink"] = title.downcase.gsub(/\s+/, "_").gsub(/[^a-zA-Z0-9_]+/, "")
	end
	
	#def to_param
	#	"#{id}-#{permalink}"
	#end
end
