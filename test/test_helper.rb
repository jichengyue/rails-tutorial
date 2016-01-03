ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'

MiniTest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  #如果用户已登录，返回true
  def is_logged_in?
  	!session[:user_id].nil?
  end

  def log_in_as(user,option={})
  	password = option[:password] || 'password'
  	remember_me = option[:remember_me] || '1'
  	if integration_test?
  		post login_path,session:{
  			email: user.email,
  			password: password,
  			remember_me: remember_me}
  	else
  		session[:user_id] = user.id
  	end
  end

  private
  	#在集成测试中返回true
  	def integration_test?
  		defined?(post_via_redirect)
  	end
end
