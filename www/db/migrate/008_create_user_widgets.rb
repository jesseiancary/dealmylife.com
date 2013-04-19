class CreateUserWidgets < ActiveRecord::Migration
	def change
		create_table :user_widgets do |t|
			t.integer :user_id, :null => false
			t.integer :widget_id, :null => false
			
			t.string :container, :limit => 64
			t.integer :order, :null => false, :default => 1000

			t.timestamps
		end
	end
end
