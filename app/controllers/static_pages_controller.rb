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
    @title_results = Book.where("title like ?", "%#{params[:query]}%")
    
    @author_results = Book.find_by_sql ["select b.* from books b, authors a where a.id = b.author_id and a.first_name || ' ' || a.last_name like ? limit 0,8", "%#{params[:query]}%"]
    
    @title_results = @title_results.concat(@author_results)
    
    @title_results.each do |b|
      b.get_google_book_info
    end
  end
  
  def books
    @books_most_reviewed = Book.find_by_sql "select b.* from books b, reviews r where b.id = r.book_id group by b.id order by count(r.book_id) DESC limit 0,4"
    
    @books_most_reviewed.each do |b1|
      Rails.logger.info "b1.get_google_book_info called for " + b1.title
      b1.get_google_book_info
    end
    
    @books_highest_rated = Book.find_by_sql "select b.* from books b, reviews r where b.id = r.book_id group by b.id having count(r.book_id) > 1 order by avg(r.rating) DESC limit 0,4"
      
    @books_highest_rated.each do |b2|
      Rails.logger.info "b2.get_google_book_info called for " + b2.title
      b2.get_google_book_info
    end
    
    @books_latest_added = Book.last(4)
    
    @books_latest_added.each do |b3|
      Rails.logger.info "b3.get_google_book_info called for " + b3.title
      b3.get_google_book_info
    end
  end
  
end
