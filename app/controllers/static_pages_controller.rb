class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost = current_user.microposts.build 
      # @microposts = current_user.microposts.order(created_at: :desc).paginate(page: params[:page])
      @feed_items = current_user.feed.order(id: :desc).paginate(page: params[:page], per_page: 10)
    end

  end

  def help
  end

  def about
  end

  def contact
  end

end
