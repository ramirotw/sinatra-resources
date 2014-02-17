json.links links do |link|
    json.rel link[:rel]
    json.uri defined?(entity) ? link[:uri].call(entity) : link[:uri].call
    json.method link[:method] if link[:method].present?
end