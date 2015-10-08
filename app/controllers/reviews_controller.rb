class ReviewsController < ApplicationController
  before_action :signed_in_user
  before_action :find_review, only: [:edit, :update, :like, :dislike]

  def new
    @review = book.reviews.build
  end
  
  def create
    @review = book.reviews.build(review_params)
    @review.user = current_user
    @review.rating = params[:score]
    
    if @review.save
      flash[:success] = 'Review succesfully added!'
      redirect_to author_book_url(author, book)
    else
      render 'new'
    end
  end
  
  def edit
    redirect_to(author_book_url(author, book)) unless current_user == @review.user
  end
  
  def update
    @review.rating = params[:score]
     
    if @review.update_attributes(review_params)
      flash[:success] = 'Review updated!'
      redirect_to author_book_url(author, book)
    else
      render 'edit'
    end
  end
  
  def like
    @review.increment!(:likes)
    redirect_to author_book_url(author, book)
    #render partial: 'books/review', collection: @reviews
    #render partial: 'books/review', object: @review
  end
  
  def dislike
    @review.increment!(:dislikes)
    redirect_to author_book_url(author, book)
  end
  
  private

  def author
    @author ||= Author.friendly.find(params[:author_id])
  end

  def book
    @book ||= author.books.friendly.find(params[:book_id])
  end

  def find_review
    @review ||= book.reviews.find(params[:id] || params[:review_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comments, :likes, :dislikes, :book_id, :user_id)
  end
  
end
