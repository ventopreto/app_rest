# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or create! alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create![{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create!name: 'Luke', movie: movies.first)

mad_max = Insured.create!(name: "Mad Max", cpf: "96151218000")
interceptor = Vehicle.create!(brand: "Ford", model: "Falcon GT", year: 1973,
  registration_plate: "Interceptor-v6")
Policy.create!(start_date_coverage: Date.new(1974, 5, 30),
  end_date_coverage: Date.new(2030, 5, 30), insured_id: mad_max.id, vehicle_id: interceptor.id)

marty = Insured.create!(name: "Marty McFly", cpf: "12345678901")
delorean = Vehicle.create!(brand: "DeLorean", model: "DMC-12", year: 1981,
  registration_plate: "OUTATIME")
Policy.create!(start_date_coverage: Date.new(1981, 2, 12),
  end_date_coverage: Date.new(2030, 2, 12), insured_id: marty.id, vehicle_id: delorean.id)

bo_duke = Insured.create!(name: "Bo Duke", cpf: "23456789012")
general_lee = Vehicle.create!(brand: "Dodge", model: "Charger", year: 1969,
  registration_plate: "General Lee")
Policy.create!(start_date_coverage: Date.new(1969, 1, 10),
  end_date_coverage: Date.new(2030, 1, 10), insured_id: bo_duke.id, vehicle_id: general_lee.id)

fred = Insured.create!(name: "Fred Jones", cpf: "34567890123")
mystery_machine = Vehicle.create!(brand: "Ford", model: "Econoline", year: 1978,
  registration_plate: "Mystery Machine")
Policy.create!(start_date_coverage: Date.new(1978, 5, 15),
  end_date_coverage: Date.new(2030, 5, 15), insured_id: fred.id, vehicle_id: mystery_machine.id)

sam = Insured.create!(name: "Sam Witwicky", cpf: "45678901234")
bumblebee = Vehicle.create!(brand: "Chevrolet", model: "Camaro", year: 1977,
  registration_plate: "BEE")
Policy.create!(start_date_coverage: Date.new(1977, 6, 18),
  end_date_coverage: Date.new(2030, 6, 18), insured_id: sam.id, vehicle_id: bumblebee.id)
