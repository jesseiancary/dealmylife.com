class CreateClicks < ActiveRecord::Migration
  
  def change
    create_table :clicks do |t|
      t.integer :user_id, :null => false
      t.integer :partner_id, :null => false
      t.string  :ip_address,         :limit => 15
      t.string  :url,                :limit => 256, :null => false

      t.timestamps
    end
  end
  
end