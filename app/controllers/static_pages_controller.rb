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
  
    if params[:query].blank?
      redirect_to home_url
    else
      @title_results = Book.title_search(params[:query]).limit(6)
      @author_results = Book.author_search(params[:query])
      @title_results = @title_results.concat(@author_results)
      
      @title_results.each do |b|
        Rails.logger.info "Search: get_google_book_info called for " + b.title
        b.get_google_book_info
      end
    end
    
  end
  
  def books
    @books_most_reviewed = Book.find_by_sql "select b.* from books b, reviews r where b.id = r.book_id group by b.id order by count(r.book_id) DESC limit 4"
    
    @books_most_reviewed.each do |b1|
      Rails.logger.info "Most Reviewed: get_google_book_info called for " + b1.title
      b1.get_google_book_info
    end
    
    @books_highest_rated = Book.find_by_sql "select b.* from books b, reviews r where b.id = r.book_id group by b.id having count(r.book_id) > 1 order by avg(r.rating) DESC limit 4"
      
    @books_highest_rated.each do |b2|
      Rails.logger.info "Highest Rated: get_google_book_info called for " + b2.title
      b2.get_google_book_info
    end
    
    @books_latest_added = Book.last(4)
    
    @books_latest_added.each do |b3|
      Rails.logger.info "Last Added: get_google_book_info called for " + b3.title
      b3.get_google_book_info
    end
  end
  
end
