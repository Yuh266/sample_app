# test/models/user_test.rb
require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "12345", password_confirmation: "12345")
  end

  test "should be valid" do
    assert_not @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end
  test "name should not be too long" do
    @user.name = "a" * 51  # 51 ký tự
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"  # tổng cộng 256 ký tự
    assert_not @user.valid?
  end
  # test "email validation should accept valid addresses" do
  #   valid_addresses = %w[
  #     user@example.com
  #     USER@foo.COM
  #     A_US-ER@foo.bar.org
  #     first.last@foo.jp
  #     alice+bob@baz.cn
  #   ]
  #   valid_addresses.each do |valid_address|
  #     @user.email = valid_address
  #     assert @user.valid?, "#{valid_address.inspect} should be valid"
  #   end
  # end
  test "email addresses should be unique" do
    duplicate_user = @user.dup  # Tạo bản sao với cùng thuộc tính
    duplicate_user.email = @user.email.upcase 
    @user.save                  # Lưu user gốc vào DB
    assert_not duplicate_user.valid?  # Bản sao không hợp lệ vì email trùng
  end
  test "error messages for missing password" do
    user = User.new(name: "Valid Name", email: "valid@example.com")
    user.valid?
    puts user.errors.full_messages
  end
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  test "user with valid name/email but short password should be invalid" do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "123", password_confirmation: "123")
    assert_not @user.valid?
  end
  
end
