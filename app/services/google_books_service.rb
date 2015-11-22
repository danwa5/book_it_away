class GoogleBooksService

  def self.call(isbn)
    new.call(isbn)
  end

  def call(isbn)
    begin
      GoogleBooks.search('isbn: ' + isbn.to_s).first
    rescue SocketError => e
      puts e.message
    end
  end
end