class CreateWidgets < ActiveRecord::Migration
	def change
		
		create_table :widgets do |t|
			t.string	:name,							:limit => 64,	:null => false
			t.string	:title,							:limit => 64,	:null => false
			t.text		:head,							:limit => 1000
			t.text		:content,						:limit => 1000
			t.boolean	:enabled,	:default => true,					:null => false

			t.timestamps
		end
		
	end
end
