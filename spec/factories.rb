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
  
  factory :author do
    last_name { Faker::Name.first_name }
    first_name { Faker::Name.last_name }
    dob "1950-01-01"
    nationality "USA"
  end
  
  factory :book do
    isbn "0123456789"
    title "How to Rule the World"
    publisher "Anchorsteam"
    pages 500
    author
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
#end
