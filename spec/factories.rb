FactoryGirl.define do
  factory :user do
    name     "John User"
    email    "john@user.com"
    password "foobar"
    password_confirmation "foobar"
  end
end
