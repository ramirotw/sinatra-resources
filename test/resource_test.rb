require 'test_helper'
require 'helpers'

class ResourceTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods
  include Sinatra::ResourcesApp::Test::Helpers

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def app
    ResourcesApp
  end

  def test_get_resources_should_return_200
    get '/resources'
    returns_200_with_json_content_type
  end

  def test_get_resources_should_return_records
    Resource.create(id: 1, name: 'Computadora')
    get '/resources'
    response = JSON.parse(last_response.body)
    assert_equal 1, response['resources'].count
    assert_equal 'Computadora', response['resources'][0]['name']
  end

  def test_get_resource_should_return_200
    Resource.create(id: 1)
    get '/resources/1'
    returns_200_with_json_content_type
  end

  def test_get_nonexisting_resource_should_return_404
    get '/resources/1'
    returns_404_with_json_content_type
  end

  def test_get_resource_with_non_numeric_id_should_return_400
    get '/resources/asd'
    assert_equal 400, last_response.status
  end

  def test_get_existing_resource
    Resource.create(id: 1, name: 'Computadora')
    get '/resources/1'
    resource = JSON.parse(last_response.body)
    assert_equal 'Computadora', resource['resource']['name']
  end

end
