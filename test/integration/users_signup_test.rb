require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
  	get signup_path
  	assert_no_difference 'User.count' do
  		post users_path,user:{ name: "",
  								email: "user@invalid",
  								password:"foo",
  								password_confirmation:"bar"}
  	end
  	assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information with  account activtion" do
    get signup_path
    name     = "Example User"
    email    = "example@14cells.com"
    password = "password"
    assert_difference 'User.count', 1 do
      post users_path ,user:{name:name,
        email:email,
        password:password,
        password_confirmation:password}
    #下面使用post_via_redirect是因为还要跟踪重定向之后的状态
      # post_via_redirect users_path, user: { name:  name,
      #                                       email: email,
      #                                       password:              password,
      #                                       password_confirmation: password }
    end
    #下面这行代码是确定只发送一封邮件，deliveries是一个数组，所以在开始就把
    #数组清空确保只发送一封邮件。
    assert_equal 1,ActionMailer::Base.deliveries.size
    #下面的assigns方法是获取相应动作里面的实例变量，例如在此是调用create方法
    #取得create方法里面的@user实例变量
    user = assigns(:user)
    assert_not user.activated?
    #尝试在激活之前登陆
    log_in_as(user)
    assert_not is_logged_in?
    #激活令牌无效
    get edit_account_activation_path("invalid token")
    #令牌有效，电子邮件不对
    get edit_account_activation_path(user.activation_token,email:"wrong")
    assert_not is_logged_in?
    #激活令牌有效
    get edit_account_activation_path(user.activation_token,email:user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
