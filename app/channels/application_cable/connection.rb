module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user # Implement your logic to retrieve the current user
    end

    private

    def find_verified_user
      if (verified_user = env['warden'].user)
        p "Verified User: #{verified_user}"
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
