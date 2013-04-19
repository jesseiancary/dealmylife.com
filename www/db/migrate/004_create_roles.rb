class CreateRoles < ActiveRecord::Migration
	def change
		
		create_table :roles do |t|
			t.string :name, :limit => 64, :null => false
			
			t.timestamps
		end
		
	end
end
