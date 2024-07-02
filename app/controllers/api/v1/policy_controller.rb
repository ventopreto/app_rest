class Api::V1::PolicyController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def show
    binding.pry
    @policy = Policy.find(params[:id])
    render json: {payload: policy}, status: :ok if @policy.present?
  end

  private

  def record_not_found
    render plain: "404 Not Found", status: :not_found
  end

  def policy
    {
      policy_id: @policy.id,
      start_date_coverage: @policy.start_date_coverage,
      end_date_coverage: @policy.end_date_coverage,
      insured: {
        name: @policy.insured.name,
        cpf: @policy.insured.cpf
      },
      vehicle: {
        brand: @policy.vehicle.brand,
        model: @policy.vehicle.model,
        year: @policy.vehicle.year,
        registration_plate: @policy.vehicle.registration_plate
      }
    }
  end
end
