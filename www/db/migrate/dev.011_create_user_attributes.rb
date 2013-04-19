class CreateUserAttributes < ActiveRecord::Migration
	def change
		create_table :user_attributes do |t|
			t.integer	:user_id,											:null => false
			t.integer	:attribute_id,										:null => false
			t.integer	:attribute_group_id,								:null => false
			t.integer	:attribute_data_id,									:null => false
			t.integer	:order,			:default => 0,						:null => false

			t.timestamps
		end
	end
end
