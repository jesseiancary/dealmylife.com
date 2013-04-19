class CreateAttributes < ActiveRecord::Migration
	def change
		create_table :attributes do |t|
			t.string	:name,										:limit => 64,	:null => false
			t.integer	:attribute_type_id,											:null => false
			t.integer	:attribute_group_id,										:null => false
			t.integer	:length
			t.boolean	:enabled,				:default => true,					:null => false

			t.timestamps
		end
	end
end
