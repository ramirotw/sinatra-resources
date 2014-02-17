require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym
require_relative 'routes/resources'
require_relative 'routes/bookings'
require_relative 'models/booking'
require_relative 'models/resource'
require_relative 'exceptions'
require_relative 'extensions'
require_relative 'date_range'
require_relative 'helpers'

class ResourcesApp < Sinatra::Base
  helpers Sinatra::Param
  helpers Sinatra::ResourcesApp::Helpers

  register Sinatra::ConfigFile

  register Sinatra::ResourcesApp::Routing::Resources
  register Sinatra::ResourcesApp::Routing::Bookings

  config_file 'config/settings.yml'

  ActiveRecord::Base.establish_connection(
    adapter: settings.adapter,
    database: settings.db
  )

  before do
    content_type :json
  end

  before '/resources/:id*' do
    param :id, Integer
  end

  before '/resources/:id/bookings/:booking_id' do
    param :booking_id, Integer
  end

  error ActiveRecord::RecordNotFound do
    halt 404, { error: 'Record not found' }.to_json
  end

  error BookingConflictError do
    halt 409, { error: 'The request conflicted with an existing resource' }.to_json
  end

  error 404 do
    { error: 'The specified url doesnt exist' }.to_json
  end

end
