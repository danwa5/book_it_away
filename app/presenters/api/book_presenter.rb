class Api::BookPresenter < Presenters::Base
  presents :book

  def as_json(opts = {})
    {
      'title' => book.title,
      'isbn' => book.isbn,
      'author' => book.author.name,
      'publisher' => book.publisher,
      'published_date' => book.published_date,
      'pages' => book.pages,
      'description' => book.description,
      'slug' => book.slug,
      'cover_image_url' => book.cover_image_url,
      'cover_small_image_url' => book.cover_small_image_url
    }
  end
end