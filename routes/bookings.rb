module Sinatra
  module ResourcesApp
    module Routing
      module Bookings
 
        def self.registered(app)

          # GET /resources/1/bookings?date='YYYY-MM-DD&limit=30&status=all' HTTP/1.1
          app.get '/resources/:id/bookings' do
            param :date,   Time,    default: Time.now.tomorrow.beginning_of_day
            param :limit,  Integer, in: (0..365), default: 30
            param :status, String,  in: %w[all pending approved], default: 'approved'

            @bookings =
              Resource.find(params[:id])
                      .get_bookings(
                        params[:date].beginning_of_day,
                        params[:limit],
                        params[:status].to_sym
                      )
            @resource_id = params[:id]
            @query_string = request.query_string
            jbuilder :bookings
          end

          # GET /resources/1/availability?date=YYYY-MM-DD&limit=30 HTTP/1.1
          app.get '/resources/:id/availability' do
            param :date,  Time,    required: true
            param :limit, Integer, in: (0..365), default: 30

            @date_ranges =
              Resource.find(params[:id])
                      .get_availability(
                        params[:date].utc.beginning_of_day,
                        params[:limit]
                      )
            @resource_id = params[:id]
            @query_string = request.query_string
            jbuilder :availability
          end

          app.post '/resources/:id/bookings' do
            from = params['from'].to_datetime
            to = params['to'].to_datetime

            @booking = Booking.create(
              start_date: from,
              end_date: to,
              status: :pending,
              resource_id: params[:id]
            )

            status 201

            jbuilder :new_booking
          end

          app.delete '/resources/:id/bookings/:booking_id' do
            Booking.cancel(params[:booking_id])
          end

          app.put '/resources/:id/bookings/:booking_id' do
            @booking = Booking.authorize(params[:booking_id])
            jbuilder :new_booking
          end

          app.get '/resources/:id/bookings/:booking_id' do
            @booking = Booking.find(params[:booking_id])
            @resource_id = params[:id]
            jbuilder :booking
          end

        end

      end
    end
  end
  register ResourcesApp::Routing::Bookings
end