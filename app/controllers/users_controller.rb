class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @users = User.all
    @book = Book.new
    @user = User.find(params[:id])
    @followers = @user.followers
    @following = @user.followings
    @books = @user.books
  end

  def index
    @users = User.all
    @book = Book.new
    @user = current_user
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      @users = User.all
      render :edit
      return
    end
  end

  def follow
    @user = User.find(params[:id])
    current_user.follow(@user)
    redirect_to user_path(@user)
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.unfollow(@user)
    redirect_to user_path(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
