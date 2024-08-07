class ListOfPoliciesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "ListOfPoliciesChannel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
