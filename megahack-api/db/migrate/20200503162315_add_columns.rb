class AddColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :small_businesses, :name, :trading_name
    add_column :small_businesses, :company_name, :string
    add_column :users, :gender, :integer
  end
end
