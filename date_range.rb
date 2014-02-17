class DateRange
  attr_accessor :start_date, :end_date

  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date =  end_date
  end

  def -(other)
    other.is_a?(Array) ? substract_ranges(other) : substract_range(other)
  end

  private

  def substract_range(range)
    range1 = DateRange.new(start_date, range.start_date)
    range2 = DateRange.new(range.end_date, end_date)
    [range1, range2]
  end

  def substract_ranges(ranges)
    substract([], ranges, start_date)
  end

  def substract(gaps, ranges, start_date)
    if ranges.empty?
      gaps << DateRange.new(start_date, end_date)
    else
      to = ranges.shift
      gaps << DateRange.new(start_date, to.start_date)
      gaps = substract(gaps, ranges, to.end_date)
    end

    gaps
  end
end
