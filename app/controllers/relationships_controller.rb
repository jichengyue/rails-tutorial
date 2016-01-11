class RelationshipsController < ApplicationController
	before_action :logged_in_user

	def create
		@user = User.find(params[:followed_id])
		current_user.follow(@user)
		#redirect_to user

		#修改表单后，我们要让 RelationshipsController 
		#响应 Ajax 请求。为此，我们要使用 respond_to 方法，
		#根据请求的类型生成合适的响应
		#respond_to 块中的代码更像是 if-else 语句，而不是代码序列
		respond_to do |format|
		  format.html { redirect_to @user }
		  format.js
		end
	end

	def destroy
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow(@user)
		#redirect_to user
		respond_to do |format|
		  format.html { redirect_to @user }
		  format.js
		end
	end
end
