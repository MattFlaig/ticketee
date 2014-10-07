FactoryGirl.define do
  factory :user do
  	sequence(:email) { |n| "ticket#{n}@ticket.com" }
    password "ticket123"
  end
end