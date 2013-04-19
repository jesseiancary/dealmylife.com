class CreateProfiles < ActiveRecord::Migration
	def change
		create_table :profiles do |t|
			t.integer	:user_id,											:null => false
			t.string	:first_name,	:default => "",		:limit => 64
			t.string	:middle_name,	:default => "",		:limit => 64
			t.string	:last_name,		:default => "",		:limit => 64
			t.boolean	:gender
			t.date		:birthdate
			t.boolean	:enabled,		:default => true,					:null => false

			t.timestamps
		end
	end
end
