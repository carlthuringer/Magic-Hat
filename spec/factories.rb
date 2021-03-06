# By using the symbol ':user', we get Factory Girl to simulate the User model.
# require 'active_support/core_ext/numeric'
FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person-#{n}@example.com" }
    name                  "MC Foo Bar"
    password              "foobar"
  end

  factory :task do
    description "My task description"
    association :user
  end

  factory :habit, :class => :task do
    description "My habit description"
    sequence( :schedule_attributes ) { |n| {:start_date => n.days.ago.to_s, :repeat => "1", :interval_unit => "day", :interval => 1.to_s} }
  end

  factory :completion do
    association :task
  end


end
