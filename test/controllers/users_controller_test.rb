require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
  	@string = "Ruby on Rails Tutorial Sample App"
  end
  test "should get new" do
    get :new
    assert_response :success
    assert_select "title","Sign up | #{@string}"
  end

end
