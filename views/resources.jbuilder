@resource_links = [{ rel: 'self', uri: ->(r){ resource_url(r) } }]
@links = [{ rel: 'self', uri: ->{ resources_url } }]

json.resources @resources do |resource|
  json.name resource.name
  json.description resource.description
  json.partial! 'links', links: @resource_links, entity: resource
end

json.partial! 'links', links: @links