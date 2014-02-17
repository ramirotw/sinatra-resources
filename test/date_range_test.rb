require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'active_support/all'
require File.expand_path '../../date_range', __FILE__

class TestRange < MiniTest::Unit::TestCase
  def test_new
    range = DateRange.new(Date.today, Date.today + 1.day)
    assert_equal Date.today, range.start_date
    assert_equal Date.today + 1.day, range.end_date
  end

  def test_substract
    range1 = DateRange.new(Date.today, Date.today + 3.day)
    range2 = DateRange.new(Date.today + 1.day, Date.today + 2.day)
    first, second = range1 - range2

    assert_equal Date.today, first.start_date
    assert_equal Date.today + 1.day, first.end_date

    assert_equal Date.today + 2.day, second.start_date
    assert_equal Date.today + 3.day, second.end_date
  end

  def test_substract_many
    range = DateRange.new(Date.today, Date.today + 5.day)
    range1 = DateRange.new(Date.today + 1.day, Date.today + 2.day)
    range2 = DateRange.new(Date.today + 3.day, Date.today + 4.day)
    first, second, third = range - [range1, range2]

    assert_equal Date.today, first.start_date
    assert_equal Date.today + 1.day, first.end_date

    assert_equal Date.today + 2.day, second.start_date
    assert_equal Date.today + 3.day, second.end_date

    assert_equal Date.today + 4.day, third.start_date
    assert_equal Date.today + 5.day, third.end_date
  end
end