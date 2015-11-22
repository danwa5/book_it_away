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
    @subjects_all = Category.all.order('name ASC')
  end
  
  def create
    @book = author.books.build(user_params)
    
    if @book.save
      category_ids = params[:categories]
      unless category_ids.blank?
        category_ids.each do |category_id|
          category = Category.find(category_id)
          @book.categories << category
        end
      end
      
      flash[:success] = "Book successfully added!"
      redirect_to @book.author
    else
      render 'new'
    end
  end
  
  def edit
    @categories = @book.categories
    @categories_all = Category.all.order('name ASC')
  end
  
  def update
    if @book.update_attributes(user_params)
      #retrieve selected categories from form
      subject_ids = params[:categories]
      selected = Array.new
    
      #if not already added, add category to book
      unless category_ids.blank?
        category_ids.each do |category_id|
          @category = Category.find(category_id)
          selected.push(@category)
          if not @book.categorized_under?(@category)
            @book.categories << @category
          end
        end
      end
      
      #get unselected categories and check if book is categorized under it
      #if so, delete it
      check_to_delete = Category.all - selected
      unless check_to_delete.blank?
        check_to_delete.each do |d|
          if @book.categorized_under?(d)
            @book.categories.delete(d)
          end
        end
      end
      
      flash[:success] = "Book updated!"
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

  def user_params
    params.require(:book).permit!
  end
end
