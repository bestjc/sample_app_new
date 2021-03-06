class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(params_user)
    if @user.save
      # log_in @user
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def update
    # @user = User.find(params[:id])
    if @user.update_attributes(params_user)
      flash[:success] = "Profle updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def edit
    # @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Follwing"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def params_user
      params.require(:user).permit(:name, :email,
                                   :password, :password_confirmation)
    end

    # 前置过滤器

    # 确保用户已登录
    # def logged_in_user
    #   unless logged_in?
    #     store_location
    #     flash[:danger] = "Please log in."
    #     redirect_to login_url
    #   end
    # end

    # 确保是正确的用户
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end

    # 确保是管理员
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
