# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :plan do |f|
  f.description "MyText"
  f.due_date "2011-04-16"
  f.completed false
end