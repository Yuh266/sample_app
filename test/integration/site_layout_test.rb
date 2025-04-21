require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layouts links" do
    # Truy cập trang chủ
    get root_path
    # Kiểm tra xem trang home có được render đúng không
    # assert_template 'static_pages/home'
    # Kiểm tra các liên kết trong layout
    assert_select "a[href=?]", root_path, count: 2  # Kiểm tra 2 liên kết đến trang chủ
    assert_select "a[href=?]", help_path           # Kiểm tra liên kết đến trang Help
    assert_select "a[href=?]", about_path          # Kiểm tra liên kết đến trang About
    assert_select "a[href=?]", contact_path        # Kiểm tra liên kết đến trang Contact
  end
end

