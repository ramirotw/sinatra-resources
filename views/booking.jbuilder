@booking_links = [
  { rel: 'self', uri: ->(b){ booking_url(b) } }, 
  { rel: 'resource', uri: ->(b){ resource_url(@resource_id) } }, 
  { rel: 'accept', uri: ->(b){ booking_url(b) }, method: 'PUT' }, 
  { rel: 'reject', uri: ->(b){ booking_url(b) }, method: 'DELETE' }
]

json.from @booking.start_date
json.to @booking.end_date
json.status @booking.status
json.partial! 'links', links: @booking_links, entity: @booking