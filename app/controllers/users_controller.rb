class UsersController < ApplicationController
  before_action :logged_in_user,only:[:index,:edit,:update,:destroy]
  before_action :correct_user,only:[:edit,:update]
  before_action :admin_user,only: :destroy

  def index
    #提供分页
    @users = User.paginate(page:params[:page],per_page:5)
  end

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page:params[:page])
  	#debugger
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      @user.send_activation_email
      #UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account "
      redirect_to root_url
      #log_in @user
  		# 处理注册成功的情况
  		#flash[:success] = "Welcome to the Simple app"
  		#redirect_to @user
  		#不过，也可以写成：redirect_to user_url(@user)
  	else
  		render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success]="Profile updated success"
      #处理更新成功的地方
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private
  	def user_params
  		params.require(:user).permit(:name,:email,:password,:password_confirmation)
  	end

    #事前过滤器
    #确保用户已登录
=begin

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "please log in"
        redirect_to login_url
      end
    end
    
=end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 确保是管理员
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
