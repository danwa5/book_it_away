class BooksController < ApplicationController
  before_action :find_book, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user

  def show
    @book.load_google_books_data
    @reviews = @book.reviews
    @visits = REDIS.incr("visits:author:#{@author.id}:book:#{@book.id}:totals")
  end

  def new
    @book = author.books.build
    @categories_all = Category.all
  end
  
  def create
    @book = author.books.build(book_params)
    
    if @book.save
      if params[:categories].present?
        category_ids = params[:categories].map(&:to_i)
        @book.add_categories(category_ids)
      end
      
      flash[:success] = 'Book successfully added!'
      redirect_to @book.author
    else
      render 'new'
    end
  end
  
  def edit
    @categories = @book.categories
    @categories_all = Category.all
  end
  
  def update
    if @book.update_attributes(book_params)

      # Add selected categories to book
      if params[:categories].present?
        category_ids = params[:categories].map(&:to_i)
        @book.add_categories(category_ids)
      end

      # Remove unselected categories from book
      categories_to_remove = Category.all - Category.where(id: category_ids)
      @book.remove_categories(categories_to_remove)

      flash[:success] = 'Book updated!'
      redirect_to author_book_url(@author, @book)
    else
      render 'edit'
    end
  end
  
  def destroy
    @book.destroy
    flash[:success] = 'Book deleted.'
    redirect_to @author
  end

  private
  
  def author
    @author ||= Author.friendly.find(params[:author_id])
  end

  def find_book
    @book = author.books.friendly.find(params[:id])
  end

  def book_params
    params.require(:book).permit!
  end
end
