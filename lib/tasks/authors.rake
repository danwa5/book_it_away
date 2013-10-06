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
                 
    Author.create!(last_name: "Hemingway",
                 first_name: "Ernest",
                 dob: "1899-07-21",
                 nationality: "USA")
                 
    Author.create!(last_name: "Steinbeck",
                 first_name: "John",
                 dob: "1902-02-27",
                 nationality: "USA")
                 
    Author.create!(last_name: "Alba",
                 first_name: "Jessica",
                 dob: "1981-04-28",
                 nationality: "USA")
                 
    Author.create!(last_name: "London",
                 first_name: "Jack",
                 dob: "1876-01-12",
                 nationality: "USA")
                 
    Author.create!(last_name: "Alba",
                 first_name: "Jessica",
                 dob: "1981-04-28",
                 nationality: "USA")
    
    Author.create!(last_name: "Sparks",
                 first_name: "Nicholas",
                 dob: "1965-12-31",
                 nationality: "USA")
                 
    Author.create!(last_name: "Philippa Gregory",
                 first_name: "Jessica",
                 dob: "1954-01-09",
                 nationality: "UK")                                      
  end
end
