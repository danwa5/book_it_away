class BooksController < ApplicationController

  before_action :get_author
  
  def show
    @book = @author.books.find(params[:id])
  end

  def new
    #@author = Author.find(params[:author_id])
    @book = @author.books.build
  end
  
  def create
    @book = @author.books.build(user_params)
    
    if @book.save
      flash[:success] = "Book successfully added!"
      redirect_to @book.author
    else
      render 'new'
    end
  end
  
  def edit
    @book = @author.books.find(params[:id])
  end
  
  def update
    @book = @author.books.find(params[:id])
    
    if @book.update_attributes(user_params)
      flash[:success] = "Book updated!"
      redirect_to @author
    else
      render 'edit'
    end
  end
  
  def destroy
    @book = @author.books.find(params[:id])
    @book.destroy
    flash[:success] = "Book deleted."
    redirect_to @author    
  end
  
  private
  
    def get_author
      @author = Author.find(params[:author_id])
    end

    def user_params
      params.require(:book).permit(:isbn, :title, :publisher, :pages, :author_id)
    end
  
end
