namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Author.create!(last_name: "Dickens",
                 first_name: "Charles",
                 dob: "1812-02-07",
                 nationality: "UK")
                 
    Author.create!(last_name: "Twain",
                 first_name: "Mark",
                 dob: "1835-11-30",
                 nationality: "USA")
                 
    Author.create!(last_name: "Krakauer",
                 first_name: "Jon",
                 dob: "1954-04-12",
                 nationality: "USA")
                 
    Author.create!(last_name: "Hosseini",
                 first_name: "Khaled",
                 dob: "1965-03-04",
                 nationality: "USA")
                 
    Author.create!(last_name: "Larrson",
                 first_name: "Stieg",
                 dob: "1954-08-15",
                 nationality: "Sweden")
                 
    Author.create!(last_name: "de Rosnay",
                 first_name: "Tatiana",
                 dob: "1961-09-28",
                 nationality: "France")
  end
end
