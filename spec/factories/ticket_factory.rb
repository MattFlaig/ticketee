FactoryGirl.define do
  factory :ticket do
    title "my ticket"
    description "what an interesting ticket"
    #user {|u| u.association(:user)}
  end
end