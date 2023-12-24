class JobApplicationsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    if current_user
      stream_from "job_applications_#{current_user.id}"
    else
      reject # Reject the subscription if the user is not authenticated
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
