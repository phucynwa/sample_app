class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new show create)
  before_action :correct_user, only: %i(edit update)
  before_action :verify_admin_user, only: :destroy
  before_action :load_user, except: %i(index new create)

  def index
    @users = User.page(params[:page]).per Settings.per_page
  end

  def show
    @microposts = @user.microposts.newest.page(params[:page]).per Settings.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".please_check_email"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t ".user_deleted"
    redirect_to users_path
  end

  def following
    @title = t ".following"
    @user = User.find_by id: params[:id]
    if @user
      @users = @user.following.page params[:page]
      render "show_follow"
    else
      flash[:danger] = t ".user_not_exist"
      redirect_to home_path
    end
  end

  def followers
    @title = t ".followers"
    @user = User.find_by id: params[:id]
    if @user
      @users = @user.followers.page params[:page]
      render "show_follow"
    else
      flash[:danger] = t ".user_not_exist"
      redirect_to home_path
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t ".please_login"
      redirect_to login_path
    end
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_path unless current_user? @user
  end

  def verify_admin_user
    redirect_to root_path unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:warning] = t ".user_not_exist"
    redirect_to root_path
  end
end
