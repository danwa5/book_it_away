class SessionsController < ApplicationController

  def new
    render 'new'
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.email_confirmed
        sign_in user
        redirect_back_or authors_path
      else
        flash[:danger] = 'Please activate your account by following the instructions in the account confirmation email you received to proceed.'
        redirect_to signin_path
      end
    else
      flash[:danger] = 'Invalid email/password combination'
      redirect_to signin_path
    end
  end
  
  def destroy
    sign_out
    redirect_to root_url
  end

end
