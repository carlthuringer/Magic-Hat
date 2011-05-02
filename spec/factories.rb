# By using the symbol ':user', we get Factory Girl to simulate the User model.
FactoryGirl.define do
  factory :user do
    name                  "MC Foo Bar"
    email                 "foo@bar.com"
    password              "foobar"
    password_confirmation "foobar"
  end

  sequence :email do |n|
    "person-#{n}@example.com"
  end

  factory :goal do
    title "Example"
    description "An example description of the goal."
    active false
    association :user
  end

  factory :task do
    description "My task description"
    complete nil
    association :goal
  end

end
