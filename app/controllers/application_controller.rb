class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  # unless Rails.application.config.consider_all_requests_local
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
    # rescue_from ActionController::RoutingError, with: lambda { |exception| render_error 404, exception }
  # end

  private

  def handle_record_not_found(err)
    redirect_to root_path
  end
  
  # def render_error(status, exception)
  #   respond_to do |format|
  #     format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
  #     format.all { render nothing: true, status: status }
  #   end
  # end
end
