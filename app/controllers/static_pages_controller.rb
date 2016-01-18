class StaticPagesController < ApplicationController
  before_action :signed_in_user, except: [:blog]
  before_action :find_archive_month, only: [:blog]

  def blog
    @posts = Post.published.posted_within(@archive_month)
  end
  
  def search
    @categories_all = Category.all
  end
  
  def results
    @books = SearchForm.search(search_params)
    display_results(@books)
  end
  
  def top10
    @books = Book.highest_rated.limit(10)
    process_google_books_info(@books)
  end
  
  private
  
    def process_google_books_info(books)
      unless books.blank?
        books.each do |b|
          b.load_google_books_data if b.cover_image.nil?
        end
      end
    end
    
    def display_results(books)
      if books.count > 0
        process_google_books_info(books)
      else
        flash[:warning] = 'No books found. Please try another search.'
        redirect_to search_path
      end
    end

    def find_archive_month
      @archive_month = params[:archive]
    end

    def search_params
      params.permit(:author, :title, :isbn, :pages, :page_operator, :categories => [])
    end
end
