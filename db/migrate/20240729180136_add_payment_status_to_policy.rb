class AddPaymentStatusToPolicy < ActiveRecord::Migration[6.1]
  def change
    change_table :policies, bulk: true do |t|
      t.string :payment_link
      t.integer :payment_status, default: 0
      t.string :payment_id
    end
  end
end
