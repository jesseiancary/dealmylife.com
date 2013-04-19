class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :name,            :limit => 64,       :null => false
      t.string :url,             :limit => 128
      t.string :url_test,        :limit => 128
      t.string :key,             :limit => 1024
      t.string :key_test,        :limit => 1024
      t.boolean :enabled, :default => true,          :null => false

      t.timestamps
    end
  end
end
