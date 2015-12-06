class AuthorsController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_author, only: [:show, :edit, :update, :destroy]
  
  def index
    #@authors = Author.paginate(page: params[:page])
    @authors = Author.all
    @visits = REDIS.incr("visits:authorsIndex:totals")
  end
  
  def show
    @books = @author.books.each do |b|
      b.load_google_books_data
    end
  end
  
  def new
    @author = Author.new
  end
  
  def create
    @author = Author.new(user_params)
    if @author.save
      flash[:success] = 'Author successfully added!'
      redirect_to @author
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @author.update_attributes(user_params)
      flash[:success] = 'Author updated!'
      redirect_to @author
    else
      render 'edit'
    end
  end
  
  def destroy
    if @author.books.any?
      flash[:danger] = 'Deleting this author is not permissible!'
      redirect_to @author
    else
      @author.destroy
      flash[:success] = 'Author deleted.'
      redirect_to authors_path
    end
  end
  
  private

  def admin_user
    redirect_to(authors_path) unless current_user.admin?
  end

  def find_author
    @author = Author.friendly.find(params[:id])
  end

  def user_params
    params.require(:author).permit(:last_name, :first_name, :dob, :nationality)
  end
end
