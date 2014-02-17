@resource_links = [
  { rel: 'self', uri: ->(r){ resource_url(r) } }, 
  { rel: 'bookings', uri: ->(r){ bookings_url(r.id) } }, 
]

json.resource do
  json.name @resource.name
  json.description @resource.description
  json.partial! 'links', links: @resource_links, entity: @resource
end