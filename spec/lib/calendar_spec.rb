require 'calendar'

describe Calendar do
  it "is accessible by week" do
    history = Array.new(28, 0)
    result = []
    4.times do
      result << Array.new(7, 0)
    end
    calendar = Calendar.new(history)
    calendar.by_week.should == result
  end

  it "builds a calendar where the last entry corresponds to the day of the week" do
    # A particular Wednesday
    Date.stub!(:today).and_return(Date.new(2011, 7, 6))
    history = Array.new(28, 1)
    result = []
    3.times do
      result << Array.new(7, 1)
    end
    result << [1, 1, 1, 1, 0, 0, 0]

    calendar = Calendar.new(history)
    calendar.final_week.should == result.last
  end
end
