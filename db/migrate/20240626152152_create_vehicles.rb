class CreateVehicles < ActiveRecord::Migration[6.1]
  def change
    create_table :vehicles do |t|
      t.string :registration_plate
      t.string :brand
      t.string :model
      t.string :year

      t.timestamps
    end
  end
end
