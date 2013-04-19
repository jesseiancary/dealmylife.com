class CreatePartnerCategories < ActiveRecord::Migration
  
  def change
    create_table :partner_categories do |t|
      t.integer :partner_id,  :null => false
      t.integer :category_id,  :null => false
      t.string :partner_category_name,  :null => false, :limit => 32

      t.timestamps
    end
  end
  
end