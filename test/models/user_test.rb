require "test_helper"

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name:"bhavik", email:"bravani@gmail.com", password: "foobar", password_confirmation: "foobar")
  end

  test "user is valid" do
    assert @user.valid?
  end

  test "name should be valid" do
    @user.name = "    "
    assert_not @user.valid?
  end

  test "email should be valid" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "valid email addresses" do
    valid_addresses = %w[bhavik@gmail.com kiaan@gmail.com shaifali@gmail.com]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "invalid email addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com user@example..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email address should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email downcase after save" do
    mixed_case_email = "Foo@Example.Com"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_digest = " " * 6
    assert_not @user.valid?
  end

  test "password should be valid" do
    @user.password = @user.password_digest = "a" * 5
    assert_not @user.valid?
  end

end
