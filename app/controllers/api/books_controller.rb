class Api::BooksController < Api::ApplicationController

  def show
    if book
      render json: book.api_presenter
    else
      render json: {}, status: :not_found
    end
  end

  private

  def book
    @book ||= Book.find_by(id: params[:id])
  end
end