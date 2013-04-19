class CreateUsers < ActiveRecord::Migration
	def change
		create_table :users do |t|
			t.string	:email,							:limit => 128,	:null => false
			t.string	:hashed_password,				:limit => 64
			t.string	:authorization_token
			t.boolean	:enabled,	:default => true,					:null => false

			t.datetime	:last_login_at
			t.timestamps
		end
	end
end
