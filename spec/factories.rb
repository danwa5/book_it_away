FactoryGirl.define do
  factory :user do
    sequence(:last_name) { |n| "Last#{n}" }
    sequence(:first_name) { |n| "First#{n}" }
    username { "#{first_name}#{last_name}".downcase }
    sequence(:email) { |n| "user#{n}@email.com"}
    password '111111'
    password_confirmation '111111'
    email_confirmed true
    
    factory :admin_user do
      admin true
    end

    factory :unconfirmed_user do
      email_confirmed false
    end
  end
  
  factory :author do
    last_name { Faker::Name.first_name }
    first_name { Faker::Name.last_name }
    dob { Faker::Date.between(50.years.ago, 20.years.ago) }
    nationality 'US'
  end
  
  factory :book do
    association :author
    isbn { Faker::Number.number(10) }
    title { Faker::Book.title }
    publisher { Faker::Book.publisher }
    pages { Faker::Number.number(3) }
    description { Faker::Hipster.sentence }

    factory :travel_book do
      after(:create) do |book, _|
        category = Category.find_or_create_by(name: 'Travel')
        book.categories << category
      end
    end

    factory :fiction_book do
      after(:create) do |book, _|
        category = Category.find_or_create_by(name: 'Fiction')
        book.categories << category
      end
    end

    factory :history_fiction_book do
      after(:create) do |book, _|
        %w(History Fiction).each do |s|
          category = Category.find_or_create_by(name: s)
          book.categories << category
        end
      end
    end

    trait :with_cover_image do
      cover_image { Rails.root.join('spec/fixtures/images/cover.jpg') }
      cover_small_image { Rails.root.join('spec/fixtures/images/cover.jpg') }
    end
  end

  factory :category do
    name 'Travel'
  end

  factory :review do
    association :user
    association :book
    rating { rand(1..5) }
    comments { Faker::Hipster.paragraph(2) }
  end

  factory :post do
    association :user
    title { Faker::Hipster.sentence }
    body { Faker::Hipster.paragraph }
  end
end