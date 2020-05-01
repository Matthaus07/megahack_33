class AddABunchOfColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :street, :string
    add_column :users, :CEP, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :st_number, :string
    add_column :users, :address_observation, :string    
  end
end
