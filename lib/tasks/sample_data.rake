namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
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

def make_tasks
  10.times do
    User.first.tasks.create!(:description => Faker::Lorem.sentence(5))
  end

  User.first.tasks.all(:limit => 28).each do |task|
    task.mark_complete rand(28).days.ago
    task.save
  end
end

def make_habits
  task = User.first.tasks.first
  task.create_habit(:description => task.description,
    :schedule_attributes => { :repeat => 1, :start_date => Time.now.to_s,
      :interval_unit => 'day', :interval => 2 } )
end
