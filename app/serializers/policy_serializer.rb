class PolicySerializer < ActiveModel::Serializer
  attributes :policy_id, :start_date_coverage, :end_date_coverage
  has_one :insured, serializer: InsuredSerializer
  has_one :vehicle, serializer: VehicleSerializer

  def policy_id
    object.id
  end
end
