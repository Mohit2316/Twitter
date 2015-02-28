require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
 def setup
    @user = users(:mohit)
  end

  test "successful edit" do
  	# go to edit page of user
	get edit_user_path(@user)

	# check if template exists
	assert_template 'users/edit'

	# fill-in the form with valid user credentials + users may not want to update password every time
	name = "foobar"
	email = "abcd@gmail.com"

	# make a patch request
	patch user_path(@user) , user: { name: name,
							   email: email,
							   password: "",
							   password_confirmation: "" }

	# check for existance of flash message
	assert_not flash.empty?

	# redirect to user profile
	assert_redirected_to @user

	# check for database values after reload
	@user.reload 
	assert_equal @user.name, name
	assert_equal @user.email, email							   


  end

  test "unsuccessful edits" do 
  	get edit_user_path(@user)
  	assert_template 'users/edit'
  	patch user_path(@user), user: { name:  "",
                                    email: "foo@invalid",
                                    password:              "foo",
                                    password_confirmation: "bar" }
    assert_template 'users/edit'
  end
end
