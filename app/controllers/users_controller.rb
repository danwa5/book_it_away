class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:show, :edit, :update]
  before_action :admin_user,     only: [:index, :destroy]

  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find_by(username: params[:id])
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.registration_confirmation(@user).deliver
      flash[:success] = 'Please confirm your email address to continue.'
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'Account settings updated!'
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    user = User.find_by(username: params[:id], admin: false)
    if user
      user.destroy
      flash[:success] = "User #{params[:id]} has been deleted."
    else
      flash[:warning] = "There was a problem deleting user #{params[:id]}"
    end
    redirect_to users_path
  end

  def confirm_email
    user = User.find_by(confirm_token: params[:id])
    if user
      user.email_activate
      sign_in user
      flash[:success] = 'Welcome to the Book-It-Away App! Your account has been confirmed.'
      redirect_to authors_path
    else
      flash[:danger] = 'Sorry. User does not exist.'
      redirect_to root_url
    end
  end

  private

    def user_params
      params.require(:user).permit(:last_name, :first_name, :name, :username, :email,
                                   :password, :password_confirmation)
    end

    def correct_user
      @user = User.find_by(username: params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
