namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_goals
    make_tasks
  end
end

def make_users
  admin = User.create!(:name => "Example User",
               :email => "example@google.com",
               :password => "foobar",
               :password_confirmation => "foobar",
               :website => "http://www.google.com",
               :biography => Faker::Lorem.paragraph(3))
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
  user = User.first
  3.times do
    user.goals.create!(:title => Faker::Lorem.words(3).join(' '), :description => Faker::Lorem.sentence(5))
  end
end

def make_tasks
  User.first.goals.all.each do |goal|
    10.times do
      goal.tasks.create!(:description => Faker::Lorem.sentence(5))
    end
  end
  User.first.tasks.all(:limit => 28).each do |task|
    task.complete = rand(28).days.ago
    task.save
  end
end
