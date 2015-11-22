class GbController < ApplicationController

  def create
    author = Author.where(last_name: author_params[:last_name], first_name: author_params[:first_name]).first_or_initialize
    author.nationality = 'USA'

    book_params = author_params[:books_attributes].values.first
    book = Book.where(isbn: book_params[:isbn]).first_or_initialize

    if author.save
      book.author = author
      book.update_attributes(book_params)

      flash[:success] = 'Author and book data successfully imported!'
      redirect_to author
    else
      flash[:error] = "Author and book data could not be imported for ISBN #{book_params[:isbn]}."
      render 'search'
    end
  end

  def search
  end

  def results
    if params[:isbn].blank?
      flash[:error] = 'ISBN is blank!'
      redirect_to search_gb_index_path
    end

    @gbook = GoogleBooksService.call(params[:isbn])

    if @gbook.nil?
      flash[:error] = 'ISBN cannot be found in Google Books API!'
      redirect_to search_gb_index_path
    else
      @author = Author.new
      @author.last_name = @gbook.authors_array.first.rpartition(' ').last
      @author.first_name = @gbook.authors_array.first.rpartition(' ').first
      @author.nationality = 'USA'

      @author.books.build(
        title: @gbook.title,
        isbn: @gbook.isbn_10,
        publisher: @gbook.publisher,
        published_date: @gbook.published_date,
        pages: @gbook.page_count,
        description: @gbook.description
      )
    end
  end

  private

  def author_params
    params.require(:author).permit(:last_name, :first_name,
      books_attributes: [:isbn, :title, :publisher, :published_date, :pages, :description])
  end

end