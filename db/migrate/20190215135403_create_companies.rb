class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :email
      t.string :address
      t.string :phone
      t.string :license
      t.string :subdomain

      t.timestamps
    end
  end
end
