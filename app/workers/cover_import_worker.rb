class CoverImportWorker
  include Sidekiq::Worker

  def perform(book_id, cover_image_url=nil)
    book = Book.find_by(id: book_id)
    return false if book.nil?

    if cover_image_url.present?
      response = HTTParty.get(cover_image_url)
      return false unless response.code == 200
      book.update!(cover_image_url: cover_image_url)
    else
      gbook = GoogleBooksService.call(book.isbn)
      if gbook.image_link.present?
        book.update!(cover_image_url: gbook.image_link)
      else
        return false
      end
    end
    return book.id
  end
end
