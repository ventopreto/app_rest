class PolicyPaid
  include Sneakers::Worker

  from_queue "policy_paid", ack: true

  def work(message)
    puts "[x] Received: #{message}"
    response = JSON.parse(message)
    order_id = response["metadata"]["order_id"]
    return if order_id.blank? || response["payment_status"] != "paid"
    policy = Policy.find_by(payment_id: order_id)
    policy.update(payment_status: 1)
    ack!
  end
end
