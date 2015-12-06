class StaticPagesController < ApplicationController
  before_action :signed_in_user, except: [:home]

  def home
  end
  
  def search
    @categories_all = Category.all
  end
  
  def results
    @results = Array.new
    
    if !params[:author].blank? || !params[:title].blank? || !params[:isbn].blank? || !params[:pages].blank? || !params[:categories].blank?
      query = Book.where("1=1")
      
      if not params[:author].blank?
        query = Book.author_search(params[:author])
      end
         
      if not params[:title].blank?
        if Rails.env.production?
          query = query.where("title ilike ?", "%#{params[:title]}%")
        else
          query = query.where("title like ?", "%#{params[:title]}%")
        end
      end
      
      if not params[:isbn].blank?
        query = query.where("isbn = ?", "#{params[:isbn]}")
      end
      
      if not params[:pages].blank?
        query = query.where("pages " + params[:page_operator] + " ?", "#{params[:pages]}")
      end
      
      if not params[:categories].blank?
        categories = params[:categories]
        categories.each do |category|
          query = query & Book.joins(:categories).where("name = ?", "#{category}")
        end
      end
      
      @results = query.take(12)
      display_results(@results)
      
    elsif !params[:query].blank?
      @results = Book.title_search(params[:query])
      author_results = Book.author_search(params[:query])
      @results = @results.concat(author_results).take(12)
      display_results(@results)
    else
      redirect_to search_path
    end
  end
  
  def top10
    @books = Book.highest_rated.limit(10)
    process_google_books_info(@books)
  end
  
  private
  
    def process_google_books_info(books)
      unless books.blank?
        books.each do |b|
          b.load_google_books_data
        end
      end
    end
    
    def display_results(results)
      if results.count > 0
        process_google_books_info(results)
      else
        flash[:warning] = "No books found. Please try another search."
        redirect_to search_path
      end
    end
  
end
