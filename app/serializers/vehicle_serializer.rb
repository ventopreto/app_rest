class VehicleSerializer < ActiveModel::Serializer
  attributes :brand, :model, :year, :registration_plate
end
