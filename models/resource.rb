class Resource < ActiveRecord::Base
  has_many :bookings

  def get_bookings(from, limit, status = :all)
    bookings = self.bookings.contained(from..to(from, limit))
    bookings = bookings.having_status(status) unless status == :all
    bookings
  end

  def get_availability(from, limit)
    date_ranges = get_bookings(from, limit).to_range
    date_range = DateRange.new(from, to(from, limit))
    date_range - date_ranges
  end

  def occupied(range)
    bookings.having_status(:approved).overlaps(range).any?
  end

  private

  def to(from, limit)
    from + limit.days
  end
end