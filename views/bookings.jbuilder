@booking_links = [
  { rel: 'self', uri: ->(b){ booking_url(b) } }, 
  { rel: 'resource', uri: ->(b){ resource_url(b.resource) } },
  { rel: 'accept', uri: ->(b){ booking_url(b) }, method: 'PUT' }, 
  { rel: 'reject', uri: ->(b){ booking_url(b) }, method: 'DELETE' }, 
]

@links = [ { rel: 'self', uri: ->{ bookings_url(@resource_id, @query_string) } } ]

json.bookings @bookings do |booking|
  json.start booking.start_date
  json.end booking.end_date
  json.status booking.status
  json.user booking.user
  json.partial! 'links', links: @booking_links, entity: booking
end

json.partial! 'links', links: @links