class PolicyPaid
  include Sneakers::Worker

  from_queue "policy_paid", ack: true

  def work(message)
    response = JSON.parse(message)
    order_id = response["metadata"]["order_id"]
    return ack! if order_id.blank? || response["payment_status"] != "paid"

    policy = Policy.find_by(payment_id: order_id)
    if policy
      policy.update(payment_status: 1)
      ActionCable.server.broadcast "ListOfPoliciesChannel", policy
    else
      Sneakers.logger.error "Policy with payment_id #{order_id} not found"
    end

    ack!
  rescue JSON::ParserError => e
    Sneakers.logger.error "Failed to parse message: #{e.message}"
    reject!
  rescue => e
    Sneakers.logger.error "Unexpected error: #{e.message}"
    reject!
  end
end
