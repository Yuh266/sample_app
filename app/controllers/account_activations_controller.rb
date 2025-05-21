class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate # Goi ham model
      log_in user
      flash[:success] = "Account activated!" 
      redirect_to user
    else
      flash[:danger] = "Invalid activation link" ##"Liên kết kích hoạt không hợp lệ"
      redirect_to root_url
    end
  end
  
end


