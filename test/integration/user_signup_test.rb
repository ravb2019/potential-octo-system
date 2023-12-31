require "test_helper"

class UserSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path params: { user: { name: "",
                                         email: "bravani@gmail.com",
                                         password: "foo",
                                         password_confirmation: "bar"
                                        }
                                }
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path params: { user: { name: "bhavik",
                                        email: "bravani@gmail.com",
                                        password: "foobar",
                                        password_confirmation: "foobar"
                                      }
                               }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash[:success].empty?
    assert is_logged_in?
  end
end
