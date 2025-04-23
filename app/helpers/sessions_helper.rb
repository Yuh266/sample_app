module SessionsHelper
  # Đăng nhập người dùng
  def log_in(user)
    session[:user_id] = user.id
    # session[:session_token] = user.session_token
  end
  def log_out
    # forget(current_user) 
    session.delete(:user_id)
    @current_user = nil
  end
  def logged_in? 
    session[:user_id].present?
  end

  # Nhớ người dùng trong phiên làm việc kéo dài
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Trả về người dùng tương ứng với token nhớ trong cookie
  def current_user
    if (user_id = session[:user_id])
      User.find_by(id: user_id)
    end
  end
  # end
  # Trả về true nếu người dùng đã cho là người dùng hiện tại
  def current_user?(user)
    user && user == current_user
  end
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      forwarding_url = session[:forwarding_url]
      reset_session
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      log_in user
      redirect_to forwarding_url || user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end
end

