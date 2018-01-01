FactoryBot.define do
  factory :user do
    sequence(:username) {|n| "sulmanweb#{n}"}
    sequence(:email) {|n| "sulmanweb#{n}@gmail.com"}
    password "abcd@1234"
  end
end
