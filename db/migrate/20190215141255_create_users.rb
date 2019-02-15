class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :phone
      t.string :address
      t.integer :salary
      t.integer :bonus
      t.references :department

      t.timestamps
    end
  end
end
