module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out 
    reset_session
    @current_user = nil
  end

   # Trả về người dùng hiện tại (nếu có).
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  # Trả về true nếu người dùng đã đăng nhập, false nếu không
  def logged_in?
    !current_user.nil?
  end


end
