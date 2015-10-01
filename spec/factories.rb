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
    dob { Faker::Date.between(50.years.ago, 20.years.ago) }
    nationality "USA"
  end
  
  factory :book do
    association :author
    isbn { Faker::Number.number(10) }
    title { Faker::Book.title }
    publisher { Faker::Book.publisher }
    pages { Faker::Number.number(3) }

    factory :travel_book do
      after(:create) do |book, _|
        subject = Subject.find_or_create_by(name: 'Travel')
        book.subjects << subject
      end
    end

    factory :fiction_book do
      after(:create) do |book, _|
        subject = Subject.find_or_create_by(name: 'Fiction')
        book.subjects << subject
      end
    end

    factory :history_fiction_book do
      after(:create) do |book, _|
        %w(History Fiction).each do |s|
          subject = Subject.find_or_create_by(name: s)
          book.subjects << subject
        end
      end
    end
  end

  factory :subject do
    name 'Travel'
  end

  # factory :book_subject do
  #   association :book
  #   association :subject
  # end

end