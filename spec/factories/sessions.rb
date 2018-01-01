FactoryBot.define do
  factory :session do
    utoken "MyString"
    last_used_at "2018-01-01 22:17:05"
    active true
    association :user
  end
end
