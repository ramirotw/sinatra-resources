require 'test_helper'
require 'helpers'

class BookingTest < MiniTest::Unit::TestCase
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

  def test_get_bookings_should_return_200
    Resource.create(id: 1)
    get '/resources/1/bookings'
    returns_200_with_json_content_type
  end

  def test_get_bookings_should_return_404_if_resource_doesnt_exist
    get '/resources/1/bookings'
    returns_404_with_json_content_type
  end

  def test_get_bookings_with_default_date_should_return_bookings_from_tomorrow
    resource = Resource.create(id: 1)
    Booking.create(
      status: 'approved',
      resource: resource,
      start_date: Time.now.tomorrow,
      end_date: Time.now.tomorrow + 1.hour
    )
    get '/resources/1/bookings'
    response = JSON.parse(last_response.body)
    assert_equal 1, response['bookings'].count
  end

  def test_get_bookings_with_default_limit_should_return_bookings_up_to_30_days
    resource = Resource.create(id: 1)
    from = Time.now.beginning_of_day + 30.days
    Booking.create(
      status: 'approved',
      resource: resource,
      start_date: from,
      end_date: from + 1.hour
    )
    get '/resources/1/bookings'
    response = JSON.parse(last_response.body)
    assert_equal 1, response['bookings'].count
  end

  def test_get_bookings_with_incorrect_lower_limit_should_return_400
    get '/resources/1/bookings', limit: -1
    assert_equal 400, last_response.status
  end

  def test_get_bookings_with_incorrect_upper_limit_should_return_400
    get '/resources/1/bookings', limit: 366
    assert_equal 400, last_response.status
  end

  def test_get_bookings_with_incorrect_status_should_return_400
    get '/resources/1/bookings', status: 'boom'
    assert_equal 400, last_response.status
  end

  def test_get_bookings_with_valid_arguments_should_return_booking
    resource = Resource.create(id: 1)
    Booking.create(
      status: 'pending',
      resource: resource,
      start_date: DateTime.new(2013, 12, 7, 16),
      end_date: DateTime.new(2013, 12, 7, 17)
    )
    from = Date.new(2013, 12, 6)
    get '/resources/1/bookings', date: from, limit: 2, status: 'pending'
    response = JSON.parse(last_response.body)
    assert_equal 1, response['bookings'].count
  end

  def test_get_availability_without_date_should_return_400
    get '/resources/1/availability'
    assert_equal 400, last_response.status
  end

  def test_get_availability_with_date_should_return_200
    Resource.create(id: 1)
    get '/resources/1/availability', date: Date.today.to_param
    returns_200_with_json_content_type
  end

  def test_get_availability
    resource = Resource.create(id: 1)
    Booking.create(
      status: 'approved',
      resource: resource,
      start_date: DateTime.new(2013, 12, 7, 16),
      end_date: DateTime.new(2013, 12, 7, 17)
    )
    from = Date.new(2013, 12, 7).to_param
    get '/resources/1/availability', date: from, limit: 2
    response = JSON.parse(last_response.body)
    assert_equal 2, response['availability'].count
  end

  def test_create_booking
    Resource.create(id: 1)
    from = DateTime.new(2013, 12, 7, 16)
    to = DateTime.new(2013, 12, 7, 17)

    post '/resources/1/bookings', from: from, to: to
    response = JSON.parse(last_response.body)

    assert_equal 201, last_response.status
    assert_equal from, response['book']['from']
    assert_equal to, response['book']['to']
    assert_equal 'pending', response['book']['status']
  end

  def test_create_booking_that_overlaps_approved_should_return_409
    resource = Resource.create(id: 1)
    from = DateTime.new(2013, 12, 7, 16)
    to = DateTime.new(2013, 12, 7, 18)
    Booking.create(
      status: 'approved',
      resource: resource,
      start_date: from,
      end_date: to
    )
    body = { from: from + 1.hour, to: to + 1.hour }

    post '/resources/1/bookings', body

    returns_409_with_json_content_type
  end

  def test_post_booking_that_overlaps_pending_should_return_201
    resource = Resource.create(id: 1)
    from = DateTime.new(2013, 12, 7, 16)
    to = DateTime.new(2013, 12, 7, 18)
    Booking.create(
      status: 'pending',
      resource: resource,
      start_date: from,
      end_date: to
    )
    body = { from: from, to: to }

    post '/resources/1/bookings', body

    assert_equal 201, last_response.status
  end

  def test_cancel_nonexisting_booking_should_return_404
    Resource.create(id: 1)

    delete '/resources/1/bookings/1'

    returns_404_with_json_content_type
  end

  def test_cancel_existing_booking_should_return_200
    resource = Resource.create(id: 1)
    Booking.create(
      id: 1,
      status: 'pending',
      resource: resource,
      start_date: DateTime.now,
      end_date: DateTime.now + 1.hour
    )

    delete '/resources/1/bookings/1'

    assert_equal 200, last_response.status
    assert_predicate last_response.body, :empty?
  end

  def test_authorize_nonexisting_booking_should_return_404
    Resource.create(id: 1)

    put '/resources/1/bookings/1'

    returns_404_with_json_content_type
  end

  def test_authorize_booking_that_overlaps_approved_should_return_409
    resource = Resource.create(id: 1)
    from = DateTime.new(2013, 12, 7, 16)
    to = DateTime.new(2013, 12, 7, 17)
    Booking.create(
      id: 1,
      status: 'pending',
      resource: resource,
      start_date: from,
      end_date: to,
    )
    Booking.create(
      id: 2,
      status: 'approved',
      resource: resource,
      start_date: from,
      end_date: to
    )

    put '/resources/1/bookings/1'

    returns_409_with_json_content_type
  end

  def test_authorize_booking_cancels_other_pending_bookings
    resource = Resource.create(id: 1)
    from = DateTime.new(2013, 12, 7, 16)
    to = DateTime.new(2013, 12, 7, 17)
    Booking.create(
      id: 1,
      status: 'pending',
      resource: resource,
      start_date: from,
      end_date: to,
    )
    Booking.create(
      id: 2,
      status: 'pending',
      resource: resource,
      start_date: from,
      end_date: to,
    )

    put '/resources/1/bookings/1'

    assert_nil Booking.find_by_id(2)
    refute_nil Booking.find_by_id(1)
  end

  def test_authorize_booking
    from = DateTime.new(2013, 12, 7, 16)
    to = DateTime.new(2013, 12, 7, 17)
    resource = Resource.create(id: 1)
    Booking.create(
      id: 1,
      status: 'pending',
      resource: resource,
      start_date: from,
      end_date: to,
    )

    put '/resources/1/bookings/1'
    response = JSON.parse(last_response.body)

    assert_equal 200, last_response.status
    assert_equal from, response['book']['from']
    assert_equal to, response['book']['to']
    assert_equal 'approved', response['book']['status']
  end

  def test_get_booking_with_non_numeric_id_should_return_400
    get '/resources/1/bookings/asd'
    assert_equal 400, last_response.status
  end

  def test_get_booking
    resource = Resource.create(id: 1)
    from = DateTime.new(2013, 12, 7, 16)
    to = DateTime.new(2013, 12, 7, 17)
    Booking.create(
      id: 1,
      status: 'pending',
      resource: resource,
      start_date: from,
      end_date: to,
    )

    get '/resources/1/bookings/1'
    response = JSON.parse(last_response.body)

    returns_200_with_json_content_type
    assert_equal from, response['from']
    assert_equal to, response['to']
    assert_equal 'pending', response['status']
  end
end
