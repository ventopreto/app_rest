class PolicyCreated
  include Sneakers::Worker

  from_queue "policy_created", ack: true

  def work(message)
    puts "[x] Received: #{message}"
    parsed_body = JSON.parse(message)

    vehicle = Vehicle.create!(
      brand: parsed_body["vehicle"]["brand"],
      model: parsed_body["vehicle"]["model"],
      year: parsed_body["vehicle"]["year"],
      registration_plate: parsed_body["vehicle"]["registration_plate"]
    )

    insured = Insured.create!(
      name: parsed_body["insured"]["name"],
      cpf: parsed_body["insured"]["cpf"]
    )

    Policy.create!(
      start_date_coverage: Date.parse(parsed_body["start_date_coverage"]),
      end_date_coverage: Date.parse(parsed_body["end_date_coverage"]),
      insured_id: insured.id,
      vehicle_id: vehicle.id,
      payment_link: parsed_body["payment_link"],
      payment_id: parsed_body["payment_id"]
    )
    ack!
  end
end
