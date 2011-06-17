# By using the symbol ':user', we get Factory Girl to simulate the User model.
FactoryGirl.define do
  factory :user do
    name                  "MC Foo Bar"
    email                 "foo@bar.com"
    password              "foobar"
  end

  sequence :email do |n|
    "person-#{n}@example.com"
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
    schedule_attributes = {:start_date => rand(30).days.ago.to_s, :repeat => "1", :interval_unit => "day", :interval => rand(7).to_s}
    association :goal
  end

  factory :completion do
    association :task
  end


end
