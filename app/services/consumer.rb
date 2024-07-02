require "bunny"

class Consumer
  class << self
    def connection
      @connection ||= Bunny.new(host: "rabbitmq", user: "user", pass: "password").start
    end

    def channel
      @channel ||= connection.create_channel
    end

    def exchange
      @exchange ||= channel.fanout("policy_created")
    end

    def queue
      @queue ||= channel.queue("", exclusive: true)
    end

    def subscribe
      queue.bind(exchange)

      puts " [*] Waiting for logs. To exit press CTRL+C"

      begin
        queue.subscribe(block: true) do |_delivery_info, _properties, body|
          puts " [x] Received: #{body}"
          parsed_body = JSON.parse(body)

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
            vehicle_id: vehicle.id
          )
        end
      rescue Interrupt => _
        channel.close
        connection.close
        puts "Connection closed"
      rescue => e
        puts "Subscription error: #{e.message}"
      end
    end
  end
end
