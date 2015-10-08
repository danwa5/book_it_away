namespace :db do
  desc "Fill database with sample data"
  task sample_users: :environment do
    User.create!(last_name: "Jones",
                 first_name: "Coconut",
                 email: "coconut.jones@gmail.com",
                 password: "123456",
                 password_confirmation: "123456",
                 admin: true)
    49.times do |n|
      last_name  = Faker::Name.last_name
      first_name = Faker::Name.first_name
      email = "user#{n}@gmail.com"
      password  = "123456"
      User.create!(last_name: last_name,
                   first_name: first_name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end
