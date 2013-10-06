class ReviewsController < ApplicationController

  before_action :get_author_and_book
  before_action :signed_in_user

  def new
    @review = @book.reviews.build
  end
  
  def create
    @review = @book.reviews.build(review_params)
    @review.user = current_user
    
    if @review.save
      flash[:success] = "Review succesfully added!"
      redirect_to author_book_url(@author, @book)
    else
      render 'new'
    end
  end
  
  def edit
    @review = @book.reviews.find(params[:id])
    redirect_to(author_book_url(@author, @book)) unless current_user == @review.user
  end
  
  def update
    @review = @book.reviews.find(params[:id])
    
    if @review.update_attributes(review_params)
      flash[:success] = "Review updated!"
      redirect_to author_book_url(@author, @book)
    else
      render 'edit'
    end
  end
  
  def like
    @review = Review.find(params[:review_id])
    @likes_count = @review.likes
    @review.update_attribute(:likes, @likes_count+1)
    #redirect_to author_book_url(@author, @book)
    #render partial: 'books/review', collection: @reviews
    #render partial: 'books/review', object: @review
  end
  
  def dislike
    @review = Review.find(params[:review_id])
    @dislikes_count = @review.dislikes
    @review.update_attribute(:dislikes, @dislikes_count+1)
    redirect_to author_book_url(@author, @book)
  end
  
  private
    
    def get_author_and_book
      @book = Book.find(params[:book_id])
      @author = @book.author
    end
    
    def review_params
      params.require(:review).permit(:rating, :comments, :likes, :dislikes, :book_id, :user_id)
    end
  
end
