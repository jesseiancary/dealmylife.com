class CreateAddresses < ActiveRecord::Migration
	def change
		
		create_table :addresses do |t|
			t.string	:street1,	:limit => 64
			t.string	:street2,	:limit => 64
			t.string	:city,		:limit => 64
			t.integer	:state_id,					:null => false
			t.string	:zip,		:limit => 5,	:null => false
      t.decimal :lng, :precision => 15, :scale => 10
      t.decimal :lat, :precision => 15, :scale => 10

			t.timestamps
		end
	end
end
