namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(last_name: "Jones",
                 first_name: "Coconut",
                 email: "coconut@jones.com",
                 password: "111111",
                 password_confirmation: "111111",
                 admin: true)
    49.times do |n|
      last_name  = Faker::Name.last_name
      first_name = Faker::Name.first_name
      email = "user#{n}@email.com"
      password  = "111111"
      User.create!(last_name: last_name,
                   first_name: first_name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end
