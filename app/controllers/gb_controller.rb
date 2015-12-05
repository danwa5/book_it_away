class GbController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user

  def create
    author = Author.where(last_name: author_params[:last_name], first_name: author_params[:first_name]).first_or_initialize
    author.nationality = 'USA'

    book_params     = author_params[:books_attributes].values.first
    category_params = book_params[:categories_attributes].values.first

    book = Book.where(isbn: book_params[:isbn]).first_or_initialize

    if author.save
      book.author = author
      book.update_attributes(book_params)

      if category_params[:name].present?
        category = Category.where(name: category_params[:name]).first_or_create!

        if !book.categories.include?(category)
          book.categories << category
        end
      end

      flash[:success] = 'Author and book data successfully imported!'
      redirect_to author
    else
      flash[:danger] = "Author and book data could not be imported for ISBN #{book_params[:isbn]}."
      render 'search'
    end
  end

  def search
  end

  def results
    if params[:isbn].blank?
      flash[:danger] = 'ISBN is blank!'
      redirect_to search_gb_index_path
    end

    @gbook = GoogleBooksService.call(params[:isbn])

    if @gbook.nil?
      flash[:danger] = 'ISBN cannot be found in Google Books API!'
      redirect_to search_gb_index_path
    else
      @author = Author.new
      @author.last_name = @gbook.authors_array.first.rpartition(' ').last
      @author.first_name = @gbook.authors_array.first.rpartition(' ').first
      @author.nationality = 'USA'

      @book = @author.books.build(
        title: @gbook.title,
        isbn: @gbook.isbn_10,
        publisher: @gbook.publisher,
        published_date: @gbook.published_date,
        pages: @gbook.page_count,
        description: @gbook.description,
      )

      @book.categories.build(
        name: @gbook.categories
      )
    end
  end

  private

  def author_params
    params.require(:author).permit(:last_name, :first_name,
      books_attributes: [:isbn, :title, :publisher, :published_date, :pages, :description, categories_attributes: [:name]])
  end

end