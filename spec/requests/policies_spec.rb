require "rails_helper"

RSpec.describe "Policy", type: :request do
  mad_max = Insured.create!(name: "Mad Max", cpf: "96151218000")
  interceptor = Vehicle.create!(brand: "Ford", model: "Falcon GT", year: 1973,
    registration_plate: "Interceptor-v6")
  policy = Policy.create!(start_date_coverage: Date.new(1974, 5, 30),
    end_date_coverage: Date.new(2030, 5, 30), insured_id: mad_max.id, vehicle_id: interceptor.id)
  let(:wrong_id) { 10 }

  describe "GET /policy/:id" do
    context "when valid" do
      it "return status 200" do
        get "/api/v1/policy/#{policy.id}"
        expect(response).to have_http_status(:ok)
      end

      it "return a policy" do
        get "/api/v1/policy/#{policy.id}"
        expect(parsed_response[:payload][:policy_id]).to eq(policy.id)
        expect(parsed_response[:payload][:start_date_coverage]).to eq("1974-05-30")
        expect(parsed_response[:payload][:end_date_coverage]).to eq("2030-05-30")
        expect(parsed_response[:payload][:insured][:name]).to eq(mad_max.name)
        expect(parsed_response[:payload][:insured][:cpf]).to eq(mad_max.cpf)
        expect(parsed_response[:payload][:vehicle][:brand]).to eq(interceptor.brand)
        expect(parsed_response[:payload][:vehicle][:model]).to eq(interceptor.model)
        expect(parsed_response[:payload][:vehicle][:year]).to eq(interceptor.year)
        expect(parsed_response[:payload][:vehicle][:registration_plate]).to eq(interceptor.registration_plate)
      end
    end

    context "when invalid" do
      it "return status 404" do
        get "/api/v1/policy/#{wrong_id}"
        expect(response).to have_http_status(:not_found)
      end

      it "return an error" do
        get "/api/v1/policy/#{wrong_id}"
        expect(response.body).to eq("404 Not Found")
      end
    end
  end
end
