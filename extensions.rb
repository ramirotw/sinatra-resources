class Array
  def to_range
    map { |b| DateRange.new(b.start_date, b.end_date) }
  end
end