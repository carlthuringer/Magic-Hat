# By using the symbol ':user', we get Factory Girl to simulate the User model.
# require 'active_support/core_ext/numeric'
FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person-#{n}@example.com" }
    name                  "MC Foo Bar"
    password              "foobar"
  end

  factory :goal do
    title "Example"
    description "An example description of the goal."
    association :user
  end

  factory :task do
    description "My task description"
    association :goal
  end

  factory :habit, :class => :task do
    description "My habit description"
    sequence( :schedule_attributes ) { |n| {:start_date => n.days.ago.to_s, :repeat => "1", :interval_unit => "day", :interval => 1.to_s} }
    association :goal
  end

  factory :completion do
    association :task
  end


end
