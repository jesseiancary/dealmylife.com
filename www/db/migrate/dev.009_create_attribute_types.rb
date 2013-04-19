class CreateAttributeTypes < ActiveRecord::Migration
	def change
		create_table :attribute_types do |t|
			t.string	:name,							:limit => 64,	:null => false
			t.boolean	:enabled,	:default => true,					:null => false
			
			t.timestamps
		end
		
		AttributeType.create( :name => "Text Field" )
		AttributeType.create( :name => "Dropdown List" )
		AttributeType.create( :name => "Radio Buttons" )
		AttributeType.create( :name => "Check Boxes" )
		
	end
end
