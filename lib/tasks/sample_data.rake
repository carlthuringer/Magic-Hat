require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_goals
  end
end

def make_users
  admin = User.create!(:name => "Example User",
               :email => "example@google.com",
               :password => "foobar",
               :password_confirmation => "foobar")
  admin.toggle! :admin
  1.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@google.com"
    password = "password"
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end

def make_goals
  User.all(:limit => 2).each do |user|
    15.times do
      user.goals.create!(:title => "Fake Title", :description => Faker::Lorem.sentence(5))
    end
  end
end
