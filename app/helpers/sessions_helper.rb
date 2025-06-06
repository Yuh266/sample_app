module SessionsHelper
  # Đăng nhập người dùng
  def log_in(user)
    session[:user_id] = user.id
    session[:session_token] = user.session_token
  end
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  def logged_in? 
    session[:user_id].present?
  end
  # Trả về người dùng tương ứng với token nhớ trong cookie
  def current_user
    if (user_id = session[:user_id])
      user = User.find_by(id: user_id) 
      if user && session[:session_token] == user.session_token
        @current_user = user
      end
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id) 
      if user && user.authenticated?(:remember,cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  # Trả về true nếu người dùng đã cho là người dùng hiện tại
  def current_user?(user)
    user && user == current_user
  end
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id 
    cookies.permanent[:remember_token] = user.remember_token
  end
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
end





