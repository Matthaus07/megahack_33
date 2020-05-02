class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.decimal :price
      t.string :photo_url
      t.integer :quantity
      t.datetime :deleted_at, default: nil
      t.integer :small_business_id
      t.timestamps
    end
  end
end
