class ErrorsController < ApplicationController

  def error_404(exception)
    @not_found_path = params[:not_found]
    render status: 404
  end
  
  def error_500(exception)
    render status: 500
  end
  
end
