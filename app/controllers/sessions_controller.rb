class SessionsController < ApplicationController
  def new
  end

  def create 
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Đăng nhập thành công
      reset_session
      log_in user
      redirect_to user
    else
      # Đăng nhập thất bại
      flash.now[:danger] = "Login failed";
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy 
    log_out
    redirect_to root_url, status: :see_other
  end

end
