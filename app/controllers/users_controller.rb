class UsersController < ApplicationController
  def new
    # debugger  
    @user = User.new

  end
  def show
    @user = User.find(params[:id])
    # debugger
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Nếu tạo người dùng thành công, chuyển hướng đến trang cá nhân của người dùng.
      flash[:success] = "Account created successfully!"
      redirect_to @user
    else
      # Nếu tạo người dùng thất bại (ví dụ: lỗi nhập liệu), hiển thị lại trang đăng ký với các lỗi.
      render 'new', status: :unprocessable_entity
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
