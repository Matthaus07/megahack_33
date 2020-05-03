class AddSubcategoryToSmallBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :small_businesses, :subcategory, :string
  end
end
