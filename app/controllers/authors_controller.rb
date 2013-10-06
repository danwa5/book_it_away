class AuthorsController < ApplicationController
  before_action :signed_in_user
  
  def index
    #@authors = Author.paginate(page: params[:page])
    @authors = Author.all.order('last_name ASC')
  end
  
  def show
    @author = Author.find(params[:id])
    @books = @author.books.where(author_id: @author.id)
    
    @books.each do |b|
      b.get_google_book_info
    end
  end
  
  def new
    @author = Author.new
  end
  
  def create
    @author = Author.new(user_params)
    if @author.save
      flash[:success] = "Author successfully added!"
      redirect_to @author
    else
      render 'new'
    end
  end
  
  def edit
    @author = Author.find(params[:id])
  end
  
  def update
    @author = Author.find(params[:id])
    if @author.update_attributes(user_params)
      flash[:success] = "Author updated!"
      redirect_to @author
    else
      render 'edit'
    end
  end
  
  def destroy
    Author.find(params[:id]).destroy
    flash[:success] = "Author deleted."
    redirect_to authors_url
  end
  
  private

    def user_params
      params.require(:author).permit(:last_name, :first_name, :dob, :nationality)
    end 
  
end
