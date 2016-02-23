class CoverImportBatchWorker
  include Sidekiq::Worker

  def perform
    books = Book.where(cover_image_uid: nil).select(:id)
    return false if books.empty?

    books.each do |book|
      CoverImportWorker.perform_async(book.id)
    end
  end
end
