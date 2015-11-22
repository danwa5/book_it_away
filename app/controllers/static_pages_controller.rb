class StaticPagesController < ApplicationController

  def home
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
  
  def search
    @subjects_all = Subject.all.order('name ASC')
  end
  
  def results
    @results = Array.new
    
    if !params[:author].blank? || !params[:title].blank? || !params[:isbn].blank? || !params[:pages].blank? || !params[:subjects].blank?
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
      
      if not params[:subjects].blank?
        subjects = params[:subjects]
        subjects.each do |subject|
          query = query & Book.joins(:subjects).where("name = ?", "#{subject}")
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
  
  def books
    @books_most_reviewed = Book.find_by_sql "select b.* from books b, reviews r where b.id = r.book_id group by b.id order by count(r.book_id) DESC limit 4"
    
    @books_highest_rated = Book.find_by_sql "select b.* from books b, reviews r where b.id = r.book_id group by b.id having count(r.book_id) > 1 order by avg(r.rating) DESC limit 4"
    
    @books_latest_added = Book.last(4)
    
    process_google_books_info(@books_most_reviewed)
    process_google_books_info(@books_highest_rated)
    process_google_books_info(@books_latest_added)
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
        flash[:alert] = "No books found. Please try another search."
        redirect_to search_path
      end
    end
  
end
