class Policy < ApplicationRecord
  belongs_to :insured
  belongs_to :vehicle

  enum payment_status: {waiting_payment: 0, paid: 1}
end
