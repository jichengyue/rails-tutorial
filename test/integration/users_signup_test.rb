require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "invalid signup information" do
  	get signup_path
  	assert_no_difference 'User.count' do
  		post users_path,user:{ name: "",
  								email: "user@invalid",
  								password:"foo",
  								password_confirmation:"bar"}
  	end
  	assert_template 'users/new'
  end

  test "valid signup information" do
    get signup_path
    name     = "Example User"
    email    = "example@14cells.com"
    password = "password"
    assert_difference 'User.count', 1 do
    #下面使用post_via_redirect是因为还要跟踪重定向之后的状态
      post_via_redirect users_path, user: { name:  name,
                                            email: email,
                                            password:              password,
                                            password_confirmation: password }
    end
    assert_template 'users/show'
    assert is_logged_in?
  end
end
