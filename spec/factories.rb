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
    complete nil
    association :goal
  end

  factory :habit do
    description "Factory habit"
    schedule_atts.start_date Time.now.to_s
    schedule_atts.interval_unit 'day'
    schedule_atts.interval '2'
    schedule_atts.repeat '1'
    association :goal
  end

end
