class BooksController < ApplicationController
  before_action :find_author
  before_action :find_book, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user
  
  def show
    @book.get_google_book_info(request.remote_ip)
    @reviews = @book.reviews
    @visits = REDIS.incr("visits:author:#{@author.id}:book:#{@book.id}:totals")
  end

  def new
    @book = @author.books.build
    @subjects_all = Subject.all.order('name ASC')
  end
  
  def create
    @book = @author.books.build(user_params)
    
    if @book.save
      subject_ids = params[:subjects]
      unless subject_ids.blank?
        subject_ids.each do |subject_id|
          subject = Subject.find(subject_id)
          @book.subjects << subject
        end
      end
      
      flash[:success] = "Book successfully added!"
      redirect_to @book.author
    else
      render 'new'
    end
  end
  
  def edit
    @subjects = @book.subjects
    @subjects_all = Subject.all.order('name ASC')
  end
  
  def update
    if @book.update_attributes(user_params)
      #retrieve selected subjects from form
      subject_ids = params[:subjects]
      selected = Array.new
    
      #if not already added, add subject to book
      unless subject_ids.blank?
        subject_ids.each do |subject_id|
          @subject = Subject.find(subject_id)
          selected.push(@subject)
          if not @book.categorized_under?(@subject)
            @book.subjects << @subject
          end
        end
      end
      
      #get unselected subjects and check if book is categorized under it
      #if so, delete it
      check_to_delete = Subject.all - selected
      unless check_to_delete.blank?
        check_to_delete.each do |d|
          if @book.categorized_under?(d)
            @book.subjects.delete(d)
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
  
  def find_author
    @author = Author.friendly.find(params[:author_id])
  end

  def find_book
    @book = @author.books.friendly.find(params[:id])
  end

  def user_params
    params.require(:book).permit(:isbn, :title, :publisher, :pages, :author_id)
  end
end
