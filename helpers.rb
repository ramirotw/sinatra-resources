module Sinatra
  module ResourcesApp
    module Helpers
      
      def base_url
        request.base_url
      end

      def resources_url
        "#{base_url}/resources"
      end

      def resource_url(param)
        id = param.is_a?(Resource) ? param.id : param
        "#{resources_url}/#{id}"
      end

      def bookings_url(resource_id, query_string = '')
        url = "#{resources_url}/#{resource_id}/bookings"
        url << "?#{query_string}" if query_string.present?
        url
      end

      def booking_url(booking)
        "#{bookings_url(booking.resource_id)}/#{booking.id}"
      end

      def availability_url(resource_id, query_string)
        "#{resource_url(resource_id)}/availability?#{query_string}"
      end
      
    end
  end
end