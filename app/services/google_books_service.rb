class GoogleBooksService

  def self.call(isbn)
    new.call(isbn)
  end

  def call(isbn)
    begin
      GoogleBooks.search('isbn: ' + isbn.to_s).first
    rescue SocketError => e
      Rails.logger.info "GoogleBooksService.call failed for ISBN #{isbn}"
    end
  end
end