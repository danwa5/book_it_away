class GbController < ApplicationController

  def search
  end

  def results
    if params[:isbn].blank?
      flash[:error] = 'ISBN is blank!'
      redirect_to search_gb_index_path
    end

    @book = Book.google_books_api_isbn_search(params[:isbn])

    if @book.nil?
      flash[:error] = 'ISBN cannot be found in Google Books API!'
      redirect_to search_gb_index_path
    end
  end
end