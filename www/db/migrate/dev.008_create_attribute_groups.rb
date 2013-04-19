class CreateAttributeGroups < ActiveRecord::Migration
	def change
		
		create_table :attribute_groups do |t|
			t.string	:name,							:limit => 64,	:null => false
			t.boolean	:enabled,	:default => true,					:null => false
			
			t.timestamps
		end
		
		AttributeGroup.create( :name => "Personal" )
		AttributeGroup.create( :name => "Work" )
		
	end
end
