class CreateEnterprises < ActiveRecord::Migration[5.1]
  def change
    create_table :enterprises do |t|
      t.string :CNPJ
      t.string :username
      t.string :password_hash
      t.string :name
      t.string :session_token

      t.timestamps
    end
  end
end
