require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup 
  	@user = User.new( name: "Test User", email: "test@gmail.com", password: "foobar", password_confirmation: "foobar"  )
  end

  test "user is valid" do
  	assert @user.valid?
  end

  test "name should not be empty" do
  	@user.name = "  "
  	assert_not @user.valid?
  end

  test "email should not be empty" do
  	@user.email = "  "
  	assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
  	@user.email = "a" * 100 + "@email.com" #limit the number of characters in email to 100
  	assert_not @user.valid?
  end

  test "email address should be in proper format" do
    valid_addresses = %W[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]

    valid_addresses.each do |valid_address|
    	@user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
   end
   test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
     end
   end

   test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "microposts associated to present user must all be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem Ipsum has interesting story")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    mohit = users(:mohit)
    archer  = users(:archer)
    assert_not mohit.following?(archer)
    mohit.follow(archer)
    assert mohit.following?(archer)
    assert archer.followers.include?(mohit)
    mohit.unfollow(archer)
    assert_not mohit.following?(archer)
  end

  test "feed should have the right posts" do
    mohit = users(:mohit)
    archer  = users(:archer)
    lana    = users(:lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert mohit.feed.include?(post_following)
    end
    # Posts from self
    mohit.microposts.each do |post_self|
      assert mohit.feed.include?(post_self)
    end
    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not mohit.feed.include?(post_unfollowed)
    end
  end
  
end
