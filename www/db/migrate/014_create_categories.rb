class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name,   :limit => 32, :null => false
      t.integer :master_category_id

      t.timestamps
    end
    
  end
end
