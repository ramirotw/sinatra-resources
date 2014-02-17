class Booking < ActiveRecord::Base
  extend Enumerize

  belongs_to :resource

  enumerize :status,
            in: [:pending, :approved],
            default: :pending,
            scope: :having_status

  before_save :check_conflicts, on: [:create, :update]

  scope :contained, (lambda do |range|
    where('start_date >= ? and end_date <= ?', range.first, range.last)
  end)

  scope :overlaps, (lambda do |range|
    where(
      '(start_date >= :start and (start_date < :end and end_date >= :end)) or
       (end_date <= :end and (start_date <= :start and end_date > :start))',
      start: range.first, end: range.last
    )
  end)

  scope :all_except, ->(booking) { where.not(id: booking.id) }

  scope :pending, -> { where(status: :pending) }

  def self.cancel(id)
    destroy(id) if find(id).status.pending?
  end

  def self.cancel_all(bookings)
    bookings.destroy_all
  end

  def self.authorize(id)
    booking = find(id)
    range = booking.start_date..booking.end_date
    resource = Resource.find(booking.resource_id)

    fail BookingConflictError if resource.occupied(range)

    pending_bookings =
      resource.bookings
              .pending
              .all_except(booking)
              .overlaps(range)

    Booking.cancel_all(pending_bookings)

    booking.status = :approved
    booking.save

    booking
  end

  def check_conflicts
    fail BookingConflictError if
      Resource.find(resource_id).occupied(start_date..end_date)
  end
end