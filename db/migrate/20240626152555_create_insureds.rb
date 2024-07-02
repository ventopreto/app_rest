class CreateInsureds < ActiveRecord::Migration[6.1]
  def change
    create_table :insureds do |t|
      t.string :name
      t.string :cpf

      t.timestamps
    end
  end
end
