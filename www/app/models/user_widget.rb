class UserWidget < ActiveRecord::Base
	belongs_to :user
	belongs_to :widget
	
	after_save :reorder_widgets
	def reorder_widgets
		
	end
	
end
