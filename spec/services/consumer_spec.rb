require "rails_helper"
require "bunny-mock"

RSpec.describe Consumer do
  let(:connection) { BunnyMock.new }
  let(:channel) { connection.create_channel }
  let(:queue) { channel.queue("", exclusive: true) }
  let(:message) do
    {
      start_date_coverage: "1994-10-05",
      end_date_coverage: "1998-11-10",
      vehicle: {
        brand: "DeLorean",
        model: "DMC-12",
        year: "1981",
        registration_plate: "OUTATIME"
      },
      insured: {
        name: "Marty McFly",
        cpf: "12345678901"
      }
    }
  end

  before do
    allow(Bunny).to receive(:new).and_return(connection)
  end

  describe ".subscribe" do
    it "consume messages from the policy_created exchange and persist data" do
      allow(queue).to receive(:subscribe).and_yield(nil, nil, message.to_json)

      expect { described_class.subscribe }.to change(Vehicle, :count).by(1)
        .and change(Policy, :count).by(1)
        .and change(Insured, :count).by(1)
      expect(Vehicle.last.registration_plate).to eq("OUTATIME")
      expect(Vehicle.last.brand).to eq("DeLorean")
      expect(Vehicle.last.model).to eq("DMC-12")
      expect(Vehicle.last.year).to eq("1981")
    end
  end

  describe ".exchange" do
    it "creates a new exchange" do
      expect(described_class.exchange).to be_a(BunnyMock::Exchange)
    end
  end

  describe ".channel" do
    it "creates a new channel" do
      expect(described_class.channel).to be_a(BunnyMock::Channel)
    end
  end

  describe ".connection" do
    it "creates a new connection" do
      expect(described_class.connection).to be_a(BunnyMock::Session)
    end
  end
end
