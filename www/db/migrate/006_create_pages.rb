class CreatePages < ActiveRecord::Migration
	def change
	  
		create_table :pages do |t|
			t.string	:name,							:limit => 64,	:null => false
			t.string	:title,							:limit => 64,	:null => false
			t.string	:permalink,					:limit => 64,	:null => false
			t.string  :location,          :limit => 32
			t.integer :order
			t.text		:content
			t.boolean	:enabled,	:default => true,					:null => false

			t.timestamps
		end
		
	end
end