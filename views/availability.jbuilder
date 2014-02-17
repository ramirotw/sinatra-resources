@availability_links = [
  { rel: 'book', uri: ->{ bookings_url(@resource_id) }, method: 'POST' },
  { rel: 'resource', uri: ->{ resource_url(@resource_id) } }
]
@links = [{ rel: 'self', uri: ->{ availability_url(@resource_id, @query_string) } }]

json.availability @date_ranges do |date_range|
  json.from date_range.start_date
  json.to date_range.end_date
  json.partial! 'links', links: @availability_links
end

json.partial! 'links', links: @links