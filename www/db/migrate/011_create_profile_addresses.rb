class CreateProfileAddresses < ActiveRecord::Migration
	def change
		create_table :profile_addresses do |t|
			t.integer :profile_id,	:null => false
			t.integer :address_id,	:null => false
      t.boolean :default, :default => false,  :null => false
			
			t.string :label, :limit => 64

			t.timestamps
		end
	end
end
