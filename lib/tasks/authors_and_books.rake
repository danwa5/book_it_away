namespace :db do
  desc 'Fill database with author and book data'
  task authors_and_books: :environment do
  
  data = [
    {
      'last_name' => 'Hemingway', 'first_name' => 'Ernest', 'dob' => '1899-07-21', 'nationality' => 'US',
      'books' => [
        { 'isbn' => '0743297332', 'title' => 'The Sun Also Rises', 'publisher' => 'Scribner', 'pages' => '256' }
      ]
    },
    {
      'last_name' => 'Dickens', 'first_name' => 'Charles', 'dob' => '1812-02-07', 'nationality' => 'UK',
      'books' => [
        { 'isbn' => '1602918074', 'title' => 'A Christmas Carol', 'publisher' => 'Saddleback Educational Publ', 'pages' => '88' },
        { 'isbn' => '0486424537', 'title' => 'Oliver Twist', 'publisher' => 'Dover Thrift Editions', 'pages' => '362' },
        { 'isbn' => '0553211765', 'title' => 'A Tale of Two Cities', 'publisher' => 'Bantam Classics', 'pages' => '416' },
        { 'isbn' => '0141199164', 'title' => 'David Copperfield', 'publisher' => 'Penguin Books', 'pages' => '984' },
        { 'isbn' => '0486415864', 'title' => 'Great Expectations', 'publisher' => 'Dover Publications', 'pages' => '400' }
      ]
    },
    {
      'last_name' => 'Twain', 'first_name' => 'Mark', 'dob' => '1835-11-30', 'nationality' => 'US',
      'books' => [
        { 'isbn' => '0486280616', 'title' => 'The Adventures of Huckleberry Finn', 'publisher' => 'Dover Publications', 'pages' => '224' }
      ]
    },
    {
      'last_name' => 'London', 'first_name' => 'Jack', 'dob' => '1876-01-12', 'nationality' => 'US',
      'books' => [
        { 'isbn' => '0141321059', 'title' => 'The Call of the Wild', 'publisher' => 'Penguin Books', 'pages' => '160' }
      ]
    },
    {
      'last_name' => 'Larrson', 'first_name' => 'Stieg', 'dob' => '1954-08-15', 'nationality' => 'SE',
      'books' => [
        { 'isbn' => '0307272117', 'title' => 'The Girl with the Dragon Tattoo', 'publisher' => 'Random House', 'pages' => '480' },
        { 'isbn' => '0307272303', 'title' => 'The Girl Who Played with Fire', 'publisher' => 'Random House', 'pages' => '512' },
        { 'isbn' => '0307593673', 'title' => 'The Girl Who Kicked the Hornet\'s Nest', 'publisher' => 'Random House', 'pages' => '576' }
      ]
    },
    {
      'last_name' => 'Krakauer', 'first_name' => 'Jon', 'dob' => '1954-04-12', 'nationality' => 'US',
      'books' => [
        { 'isbn' => '0307476863', 'title' => 'Into the Wild', 'publisher' => 'Random House', 'pages' => '207' },
        { 'isbn' => '0330470027', 'title' => 'Into Thin Air', 'publisher' => 'Pan Macmillan', 'pages' => '304' }
      ]
    },
    {
      'last_name' => 'Steinbeck', 'first_name' => 'John', 'dob' => '1902-02-27', 'nationality' => 'US',
      'books' => [
        { 'isbn' => '1440637121', 'title' => 'The Grapes of Wrath', 'publisher' => 'Penguin Books', 'pages' => '544' },
        { 'isbn' => '1440674175', 'title' => 'The Pastures of Heaven', 'publisher' => 'Penguin Books', 'pages' => '240' }
      ]
    },
    {
      'last_name' => 'de Rosnay', 'first_name' => 'Tatiana', 'dob' => '1961-09-28', 'nationality' => 'FR',
      'books' => [
        { 'isbn' => '1429985216', 'title' => 'Sarah\'s Key', 'publisher' => 'Macmillan', 'pages' => '304' }
      ]
    },
    {
      'last_name' => 'Gregory', 'first_name' => 'Philippa', 'dob' => '1954-01-09', 'nationality' => 'GB',
      'books' => [
        { 'isbn' => '1416556532', 'title' => 'The Other Boleyn Girl', 'publisher' => 'Pocket Star Books', 'pages' => '735' }
      ]
    },
    {
      'last_name' => 'Hosseini', 'first_name' => 'Khaled', 'dob' => '1965-03-04', 'nationality' => 'USA',
      'books' => [
        { 'isbn' => '0307371557', 'title' => 'The Kite Runner', 'publisher' => 'Random House', 'pages' => '400' },
        { 'isbn' => '0143180657', 'title' => 'A Thousand Splendid Suns', 'publisher' => 'Penguin Books', 'pages' => '400' },
        { 'isbn' => '0143188704', 'title' => 'And the Mountains Echoed', 'publisher' => 'Penguin Books', 'pages' => '384' }
      ]
    },
    {
      'last_name' => 'Smith', 'first_name' => 'Wilbur', 'dob' => '1933-01-09', 'nationality' => 'CA',
      'books' => [
        { 'isbn' => '0330468340', 'title' => 'Cry Wolf', 'publisher' => 'Pan Macmillan', 'pages' => '416' }
      ]
    },
    {
      'last_name' => 'Gladwell', 'first_name' => 'Malcolm', 'dob' => '1963-09-03', 'nationality' => 'CA',
      'books' => [
        { 'isbn' => '0316017930', 'title' => 'Outliers: the Story of Success', 'publisher' => 'Little, Brown, & Company', 'pages' => '336' }
      ]
    },
    {
      'last_name' => 'Alba', 'first_name' => 'Jessica', 'dob' => '1981-04-28', 'nationality' => 'US',
      'books' => [
        { 'isbn' => '1609619129', 'title' => 'The Honest Life', 'publisher' => 'Rodale', 'pages' => '272' }
      ]
    },
    {
      'last_name' => 'Sparks', 'first_name' => 'Nicholas', 'dob' => '1965-12-31', 'nationality' => 'US',
      'books' => [
        { 'isbn' => '0748119760', 'title' => 'Dear John', 'publisher' => 'Little, Brown Book Group', 'pages' => '368' }
      ]
    }
  ]

  data.each do |author|
    a = Author.create!(last_name: author['last_name'], first_name: author['first_name'], dob: author['dob'], nationality: author['nationality'])
    # puts "\nAUTHOR => last_name: #{author['last_name']}, first_name: #{author['first_name']}, dob: #{author['dob']}, nationality: #{author['nationality']}"

    unless author['books'].nil?
      books = author['books']
      books.each do |book|
        Book.create!(isbn: book['isbn'], title: book['title'], publisher: book['publisher'], pages: book['pages'], author_id: a.id)
        # puts "BOOK => isbn: #{book['isbn']}, title: #{book['title']}, publisher: #{book['publisher']}"
      end
    end
  end
  
  end
end
