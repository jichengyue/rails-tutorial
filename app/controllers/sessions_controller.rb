class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email:params[:session][:email].downcase)
  	if user and user.authenticate(params[:session][:password])
  		# 登入用户，然后重定向到用户的资料页面
      log_in user
      params[:session][:remember_me]== '1' ? remember(user) : forget(user)
      redirect_to user
      #相当于redirect_to user_url(user)
  	else
  		#创建一个错误消息
  		flash.now[:danger] = 'Invalid email/password combination' 
  		# 不完全正确
  		render 'new'
  	end
  end

  def destroy
  	log_out if logged_in?
    #root_url  'http://localhost:3000/'
    #root_path '/'
    redirect_to root_url
  end
end