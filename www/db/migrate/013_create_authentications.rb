class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :provider_uid

      t.timestamps
    end
  end
end
