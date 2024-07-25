require "rails_helper"

RSpec.describe "Policy", type: :request do
  let(:mad_max) { Insured.create!(name: "Mad Max", cpf: "96151218000") }
  let(:interceptor) do
    Vehicle.create!(brand: "Ford", model: "Falcon GT", year: 1973,
      registration_plate: "Interceptor-v6")
  end
  let(:policy) do
    Policy.create!(start_date_coverage: Date.new(1974, 5, 30),
      end_date_coverage: Date.new(2030, 5, 30), insured_id: mad_max.id, vehicle_id: interceptor.id)
  end
  let(:another_policy) do
    Policy.create!(start_date_coverage: Date.new(1974, 5, 30),
      end_date_coverage: Date.new(2030, 5, 30), insured_id: mad_max.id, vehicle_id: interceptor.id)
  end
  let(:wrong_id) { 10 }

  describe "GET /policy/:id" do
    context "when authenticated" do
      before { allow_any_instance_of(Api::V1::PolicyController).to receive(:authenticate).and_return(true) }

      context "and valid id" do
        it "return status 200" do
          get "/api/v1/policy/#{policy.id}"
          expect(response).to have_http_status(:ok)
        end

        it "return a policy" do
          get "/api/v1/policy/#{policy.id}"
          expect(parsed_response[:policy_id]).to eq(policy.id)
          expect(parsed_response[:start_date_coverage]).to eq("1974-05-30")
          expect(parsed_response[:end_date_coverage]).to eq("2030-05-30")
          expect(parsed_response[:insured][:name]).to eq(mad_max.name)
          expect(parsed_response[:insured][:cpf]).to eq(mad_max.cpf)
          expect(parsed_response[:vehicle][:brand]).to eq(interceptor.brand)
          expect(parsed_response[:vehicle][:model]).to eq(interceptor.model)
          expect(parsed_response[:vehicle][:year]).to eq(interceptor.year)
          expect(parsed_response[:vehicle][:registration_plate]).to eq(interceptor.registration_plate)
        end
      end

      context "and invalid id" do
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

    context "when not authenticated" do
      it "decode error" do
        get "/api/v1/policy/#{wrong_id}"

        expect(parsed_response[:decode_error]).to eq("Erro ao decodificar token: formato inválido ou token inexistente.")
      end

      it "expiration error" do
        allow_any_instance_of(Api::V1::PolicyController).to receive(:authenticate).and_raise(JWT::ExpiredSignature)

        get "/api/v1/policy/#{policy.id}", headers: {Authorization: "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0Iiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNzIxMjM5MDgyLCJleHAiOjE3MjEyNDA4ODIsImp0aSI6IjgzODliZTYwLTEzMjItNGUxOS05Y2JjLTI4ZjdhYmZjOTEwMiJ9.4TkLZr5VLOBo1BMIHQkYRizBpAfXrT2_LSLqZO9X-XE"}

        expect(parsed_response[:expiration_error]).to eq("Token expirado, recrie o token e tente novamente")
      end

      it "verification error" do
        allow_any_instance_of(Api::V1::PolicyController).to receive(:authenticate).and_raise(JWT::VerificationError)

        get "/api/v1/policy/#{policy.id}"

        expect(parsed_response[:invalid_token]).to eq("Erro ao verificar token: O token é inválido ou modificado")
      end
    end
  end

  describe "GET /policy" do
    context "when authenticated" do
      before { allow_any_instance_of(Api::V1::PolicyController).to receive(:authenticate).and_return(true) }

      context "and there is at least one police" do
        before do
          policy
          another_policy
        end

        it "return status 200" do
          get "/api/v1/policy"
          expect(response).to have_http_status(:ok)
        end

        it "return a list of policies" do
          get "/api/v1/policy"
          expect(parsed_response.count).to eq(2)
        end
      end

      context "and there is no policy" do
        it "return status 200" do
          get "/api/v1/policy"
          expect(response).to have_http_status(:ok)
        end

        it "return an error" do
          get "/api/v1/policy"
          expect(response.body).to eq("Não existe nenhuma Apolice")
        end
      end
    end

    context "when not authenticated" do
      it "decode error" do
        get "/api/v1/policy"

        expect(parsed_response[:decode_error]).to eq("Erro ao decodificar token: formato inválido ou token inexistente.")
      end

      it "expiration error" do
        allow_any_instance_of(Api::V1::PolicyController).to receive(:authenticate).and_raise(JWT::ExpiredSignature)

        get "/api/v1/policy/#{policy.id}", headers: {Authorization: "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0Iiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNzIxMjM5MDgyLCJleHAiOjE3MjEyNDA4ODIsImp0aSI6IjgzODliZTYwLTEzMjItNGUxOS05Y2JjLTI4ZjdhYmZjOTEwMiJ9.4TkLZr5VLOBo1BMIHQkYRizBpAfXrT2_LSLqZO9X-XE"}

        expect(parsed_response[:expiration_error]).to eq("Token expirado, recrie o token e tente novamente")
      end

      it "verification error" do
        allow_any_instance_of(Api::V1::PolicyController).to receive(:authenticate).and_raise(JWT::VerificationError)

        get "/api/v1/policy"

        expect(parsed_response[:invalid_token]).to eq("Erro ao verificar token: O token é inválido ou modificado")
      end
    end
  end
end
