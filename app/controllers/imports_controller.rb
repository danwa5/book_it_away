class ImportsController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user

  def index
  end

  def create
    author = Author.where(last_name: author_params[:last_name], first_name: author_params[:first_name]).first_or_initialize

    book_params     = author_params[:books_attributes].values.first
    category_params = book_params[:categories_attributes].values.first

    book = Book.where(isbn: book_params[:isbn]).first_or_initialize

    if author.save
      book.author = author
      book.update_attributes(book_params)
      CoverImportWorker.perform_async(book.id, params[:cover_image]) if params[:import_cover_image] == 'true'

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
      render 'index'
    end
  end

  def results
    if params[:isbn].blank?
      flash[:danger] = 'ISBN is blank!'
      redirect_to imports_path
    else
      @gbook = GoogleBooksService.call(params[:isbn])

      if @gbook.nil?
        flash[:danger] = 'ISBN cannot be found in Google Books API!'
        redirect_to imports_path
      else
        @author = Author.new({ authors_array: @gbook.authors_array })
        @book = @author.books.build({ gbook: @gbook })
        @book.categories.build(name: @gbook.categories)
      end
    end
  end

  def import_covers
    CoverImportBatchWorker.perform_async
    flash[:success] = 'Worker enqueued to import covers.'
    redirect_to request.referrer
  end

  private

  def author_params
    params.require(:author).permit(:last_name, :first_name, :cover_image, :import_cover_image,
      books_attributes: [:isbn, :title, :publisher, :published_date, :pages, :description,
      categories_attributes: [:name]])
  end

end