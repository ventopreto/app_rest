class Insured < ApplicationRecord
  has_many :policies, dependent: :destroy
end
