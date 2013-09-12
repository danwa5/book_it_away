FactoryGirl.define do
  factory :user do
    sequence(:last_name)  { |n| "Last#{n}" }
    sequence(:first_name)  { |n| "First#{n}" }
    sequence(:email) { |n| "user#{n}@email.com"}
    password "111111"
    password_confirmation "111111"
    
    factory :admin do
      admin true
    end
  end
end

#FactoryGirl.define do
#  factory :user do
#    last_name "Jones"
#    first_name "Coconut"
#    email "coconut@jones.com"
#    password "111111"
#    password_confirmation "111111"
#  end

#  factory :author do
#    last_name "Krakauer"
#    first_name "Jon"
#    dob "1954-04-12"
#    nationality "USA"
#  end
#end
