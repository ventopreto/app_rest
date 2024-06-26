class Vehicle < ApplicationRecord
  has_many :policies, dependent: :destroy
end
