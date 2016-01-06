class PostsController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user
  before_action :correct_user, except: [:show]
  before_action :find_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = user.posts
  end

  def show
  end

  def new
    @post = user.posts.build
  end

  def create
    @post = user.posts.build(post_params)
    if @post.save
      flash[:success] = 'Blog post successfully added!'
      redirect_to user_post_path(user, @post)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @post.update_attributes(post_params)
      @post.update_column(:posted_at, Time.now) if @post.posted_at.nil? && @post.publish?
      flash[:success] = 'Blog post updated!'
      redirect_to user_post_path(user, @post)
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = 'Post deleted.'
    redirect_to user_posts_path(user)
  end

  private

  def user
    @user ||= User.find_by(username: params[:user_id])
  end

  def find_post
    @post = user.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit!
  end

  def correct_user
    user = User.find_by(username: params[:user_id])
    redirect_to(root_url) unless current_user?(user)
  end
end