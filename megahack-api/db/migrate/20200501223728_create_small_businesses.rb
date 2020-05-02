class CreateSmallBusinesses < ActiveRecord::Migration[5.1]
  def change
    create_table :small_businesses do |t|
      t.string :CNPJ
      t.string :username
      t.string :password_hash
      t.string :name
      t.string :session_token
      t.string :street
      t.string :CEP
      t.string :city
      t.string :state
      t.string :st_number
      t.decimal :average_rating, default: 5.0
      t.decimal :financial_rating, default: 5.0
      t.string :address_observation
      t.integer :total_ratings, :default => 0
      t.string :category
      t.string :photo_url
      t.timestamps
    end
  end
end
