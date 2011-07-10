require 'date'
require 'rubygems'
require 'active_support/core_ext/array'

class Calendar
  def initialize(data)
    @calendar = compile(data)
  end

  def by_week
    @calendar
  end

  def final_week
    @calendar.last
  end

  private

  def compile(data)
    result = data
    (Date.today.wday + 1).times do
      result.unshift 0
    end
    result = result.in_groups_of(7, 0)
    result.shift
    return result
  end
end
