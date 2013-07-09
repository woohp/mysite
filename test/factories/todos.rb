# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :todo do
    user
    title 'my first todo!'
    description 'this is my first awesome todo!'
  end
end
