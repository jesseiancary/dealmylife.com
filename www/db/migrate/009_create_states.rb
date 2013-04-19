class CreateStates < ActiveRecord::Migration
	
	def change
		create_table :states do |t|
			t.string :name,		:limit => 32,	:null => false
			t.string :abbr,		:limit => 2,	:null => false
		end
		
	end
end
